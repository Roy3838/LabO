# Codigo de unwrapping creado por Roy Medina y Gilberto
using FFTW: dct, idct

function phase_unwrap(psi::Array{Float64})
    # get the wrapped differences of the wrapped values
    dx = [zeros(size(psi,1),1) wrapToPi(diff(psi, dims=2)) zeros(size(psi,1),1)]
    dy = [zeros(1,size(psi,2)); wrapToPi(diff(psi, dims=1)); zeros(1,size(psi,2))]
    rho = diff(dx,dims=2) + diff(dy,dims=1)
    phi = solvePoisson(rho)
    return phi
end

function solvePoisson(rho)
    # solve the poisson equation using dct
    dctRho = mapslices(dct, rho, dims=(1,2))

    N, M = size(rho)
    I, J = meshgrid(0:M-1, 0:N-1)
    dctPhi = dctRho' ./ 2 ./ (cos(pi*I/M) + cos(pi*J/N) .- 2)
    dctPhi[1,1] = 0 # handling the inf/nan value

    phi = mapslices(idct, dctPhi, dims=(1,2))
    return phi
end




# Meshgrid using external product
function meshgrid(x, y)
    return (repeat(x, outer=(length(y), 1)), repeat(y, outer=(1, length(x))))
end

function wrapToPi(x::AbstractArray{T}) where T<:Real
    return mod.(x .+ pi, 2*pi) .- pi
end







