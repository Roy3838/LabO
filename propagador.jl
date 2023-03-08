using Plots
using FFTW

# Codigo para hacer un propagador de Fourier 
# donde se encunetra un U_0 y se propaga una distancia z


# Usando propagacion de Fourier
function propagar(U_0, z, k_t, k_z)
    # U\left(r,z\right)=Fe^{-1}\left(e^{ik_{z}\left(k_{t}\right)z}Fe\left(U\left(r_{t},0\right)\right)\right)
    F_U = fft(U_0) # Transformada de Fourier de U_0
    F_U = 2.718^(im*k_z*k_t*z)*F_U # Propagacion de Fourier
    U = ifft(F_U) # Transformada inversa de Fourier
    return U
end

# Campo inicial circular
N = 1000
U_0 = zeros(Complex{Float64},N,N)

# Make a circle
R = 20
for i in 1:N
    for j in 1:N
        if (i-N/2)^2 + (j-N/2)^2 < R^2
            U_0[i,j] = 1
        end
    end
end

# Visualizar campo inicial
heatmap(abs.(U_0).^2)

# Definir variables de propagacion
# z = 1 # propagation distance
# k_t = 1 
# k_z = 1 

#heatmap(U)

