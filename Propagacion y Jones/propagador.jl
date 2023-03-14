using Plots
using FFTW

# Codigo para hacer un propagador de Fourier 
# donde se encunetra un U_0 y se propaga una distancia z


# Usando propagacion de Fourier
function propagar(U_0, z, k_x, k_y)

    F_U = fft(U_0) # Transformada de Fourier de U_0
    F_Um = exp.(im.*k_x.*k_y.*z).*F_U # Propagacion de Fourier
    U = ifft(F_Um) # Transformada inversa de Fourier
    return U
end

# Campo inicial circular
N = 512
U_0 = zeros(Complex{Float64},N,N)

# Definir variables de propagacion
z = 0.000000000003 # propagation distance

lambda = 633e-9
w0 = 0.5e-3
L = 20*w0
dx = L/N
NV = collect(-N/2:N/2-1)
xs = NV*dx
ys = NV*dx
Xs = xs'.*ones(N)
Ys = ys.*ones(N)
k_0 = 2*pi/lambda
# print shape of Xs
print(size(Xs))

k_max = pi/dx

k_x = k_max * (2/N) * NV
k_y = k_max * (2/N) * NV

#[KXs, KYs] = meshgrid(k_x, k_y)

# propagador
#kz = k_0-0.5(KXs.^2 + KYs.^2)/k_0
zr = k_0*(w0^2)/2
z = 0.5*zr
nz = 300
dz = z/nz

# Make a circle
R = 0.1*N
for i in 1:N
    for j in 1:N
        if (i-N/2)^2 + (j-N/2)^2 < R^2
            U_0[i,j] = 1
        end
    end
end

# Visualizar campo inicial
#heatmap(abs.(U_0).^2)




U = propagar(U_0, z, k_x, k_y)


heatmap(abs.(U).^2)

# Propagar

#heatmap(abs.(U).^2)

