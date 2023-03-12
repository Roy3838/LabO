# Codigo de unwrapping creado por Roy Medina y Gilberto
using FFTW

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
    dctRho = dct(dct(rho)');
    display(dctRho)
    N, M = size(rho)
    I, J = meshgrid(0:M-1, 0:N-1)
    dctPhi = dctRho ./ 2 ./ (cos(pi*I/M) + cos(pi*J/N) .- 2)
    dctPhi[1,1] = 0 # handling the inf/nan value
    
    # now invert to get the result
    phi = idct(idct(dctPhi)') # Use idct instead of idct2 in Julia
    return phi
end

function meshgrid(x, y)
    nx, ny = length(x), length(y)
    X = reshape(repeat(x, outer=(ny,)), ny, nx)'
    Y = reshape(repeat(y, inner=(nx,)), nx, ny)
    return X, Y
end

function wrapToPi(x::AbstractArray{T}) where T<:Real
    return mod.(x .+ pi, 2*pi) .- pi
end







