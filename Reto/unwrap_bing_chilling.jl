
# Codigo de unwrapping creado por Roy Medina y Gilberto
using FFTW


function phase_unwrap(psi::Array{Float64}, weight::Array{Float64}=zeros(size(psi)))
    if all(weight .== 0) # unweighted phase unwrap
        # get the wrapped differences of the wrapped values
        dx = [zeros(size(psi,1),1) wrapToPi(diff(psi, dims=2)) zeros(size(psi,1),1)]
        dy = [zeros(1,size(psi,2)); wrapToPi(diff(psi, dims=1)); zeros(1,size(psi,2))]
        rho = diff(dx,dims=2) + diff(dy,dims=1)
        
        # get the result by solving the poisson equation
        phi = solvePoisson(rho)
        
    else # weighted phase unwrap
        # check if the weight has the same size as psi
        if any(size(weight) .!= size(psi))
            error("Argument error: Size of the weight must be the same as size of the wrapped phase")
        end
        
        # vector b in the paper (eq 15) is dx and dy
        dx = [wrapToPi(diff(psi,dims=2)) zeros(size(psi,1),1)]
        dy = [wrapToPi(diff(psi,dims=1)); zeros(1,size(psi,2))]
        
        # multiply the vector b by weight square (W^T * W)
        WW = weight .* weight
        WWdx = WW .* dx
        WWdy = WW .* dy
        
        # applying A^T to WWdx and WWdy is like obtaining rho in the unweighted case
        WWdx2 = [zeros(size(psi,1),1) WWdx]
        WWdy2 = [zeros(1,size(psi,2)); WWdy]
        rk = diff(WWdx2,dims=2) + diff(WWdy2,dims=1)
        normR0 = norm(rk)
    
        # start the iteration
        eps = 1e-8
        k = 0
        phi = zeros(size(psi))
        while !all(rk .== 0)
            zk = solvePoisson(rk)
            k += 1
            
            if k == 1 
                pk = zk
            else 
                betak = sum(rk .* zk) / sum(rkprev .* zkprev)
                pk = zk + betak * pk
            end
            
            # save the current value as the previous values
            rkprev = rk
            zkprev = zk
            
            # perform one scalar and two vectors update
            Qpk = applyQ(pk, WW)
            alphak = sum(rk .* zk) / sum(pk .* Qpk)
            phi = phi + alphak * pk
            rk = rk - alphak * Qpk
            
            # check the stopping conditions
            if (k >= length(psi)) || (norm(rk) < eps * normR0)
                break
            end
        end
    end
    return phi
end


function solvePoisson(rho)
    # solve the poisson equation using dct
    dctRho = dct2(rho)
    (N, M) = size(rho)
    (I, J) = meshgrid(0:M-1, 0:N-1)
    dctPhi = dctRho ./ 2 ./ (cos.(pi*I/M) + cos.(pi*J/N) .- 2)
    dctPhi[1,1] = 0 # handling the inf/nan value
    
    # now invert to get the result
    phi = idct(dctPhi, 2) # este we esta dificil
    return phi
end

function applyQ(p, WW)
    # apply (A)
    dx = [diff(p, dims=2), zeros(size(p,1),1)] # diff este we esta dificil tambien
    dy = [diff(p, dims=1); zeros(1,size(p,2))]
    
    # apply (W^T)(W)
    WWdx = WW .* dx
    WWdy = WW .* dy
    
    # apply (A^T)
    WWdx2 = [zeros(size(p,1),1), WWdx]
    WWdy2 = [zeros(1,size(p,2)); WWdy]
    Qp = diff(WWdx2,dims=2) + diff(WWdy2,dims=1)

    return Qp
end
    
function wrapToPi(x::Array{Float64})
    return mod.(x .+ pi, 2pi) .- pi
end

function dct2(A::Array{Float64})
    return dct(dct(A))
end







