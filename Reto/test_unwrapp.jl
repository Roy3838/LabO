using DSP
using Plots
using FFTW: dct, idct

function wrapToPi(x::AbstractArray{T}) where T<:Real
    return mod.(x .+ pi, 2*pi) .- pi
end

function dct_roy(a,n=nothing)
    if !isa(a, Float64)
        a = Float64.(a)
    end

    if minimum(size(a)) == 1 
        if size(a,2) > 1
            do_trans = true
        else
            do_trans = false
        end
        a = vec(a) 
    else  
        do_trans = false 
    end
    
    if n === nothing
      n = size(a,1)
    end
    
    m = size(a,2)

    if size(a,1) < n
      aa = zeros(n,m)
      aa[1:size(a,1),:] .= a
    else
      aa = a[1:n,:]
    end

    if ((rem(n,2)==1) || (!isreal(a)))
      y = zeros(2*n,m)
      y[1:n,:] .= aa;
      y[n+1:n+n,:] .= reverse(aa,dims=1)

      yy = fft(y)

      ww = (exp.(-im*(0:n-1)*pi/(2*n))/sqrt(2*n))
      ww[1] /= sqrt(2)
      
      b=ww.*yy[1:n,:]

    else 

      y=[aa[1:2:end,:];aa[end:-2:2,:]]

      ww=2*exp.(-im*(0:n-1)'*pi/(2*n))/sqrt(2*n);
      
      ww[1] /= sqrt(2);
      
      W=ww.*ones(m)'
      
      b=W.*fft(y);
    
    end

    if isreal(a); b=real(b);end
    
    if do_trans; b=b';end
    
end

function dct2(arg1,mrows=nothing,ncols=nothing)
    m, n = size(arg1)
    if (m > 1) && (n > 1)
        b = dct_roy(dct_roy(arg1)')'
        return b
    else
        mrows = m
        ncols = n 
    end

    a = arg1
    
    mpad = mrows; npad = ncols

    if m == 1 && mpad > m 
        a[2, 1] = 0; 
        m = 2;
    end
    
    if n == 1 && npad > n 
        a[1, 2] = 0; 
        n = 2;
    end
    
    if m == 1
        mpad = npad; npad = 1;
    end

    b = dct_roy(a, mpad);
    
    if m > 1 && n > 1 
        b=dct_roy(b', npad)';
    end
    
end

include("meshgrid.jl")
# Make a meshgrid and a z plane with slope 1 in x and y direction
x = 1:100
y = 1:100
x_l, y_l = meshgrid(x, y)


# Make a cosine wave in z
z = 2*cos.(x_l/10) .+ 2*cos.(y_l/10)


# wrap z values to [-pi, pi]
z = mod.(z, 2pi) .- pi


psi = z
# get the wrapped differences of the wrapped values
dx = [zeros(size(psi,1),1) wrapToPi(diff(psi, dims=2)) zeros(size(psi,1),1)]
dy = [zeros(1,size(psi,2)); wrapToPi(diff(psi, dims=1)); zeros(1,size(psi,2))]
rho = diff(dx,dims=2) + diff(dy,dims=1)
# solve the poisson equation using dct in 2 dimensions
dctRho = mapslices(dct, rho, dims=(1,2))

N, M = size(rho)
I, J = meshgrid(0:M-1, 0:N-1)
dctPhi = dctRho ./ 2 ./ (cos(pi*I/M) + cos(pi*J/N) .- 2)
dctPhi[1,1] = 0 # handling the inf/nan value
phi = mapslices(idct, dctPhi, dims=(1,2))

plotlyjs()
surface(phi, camera=(30, 60))





