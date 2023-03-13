# Holografia binaria
using Plots

Ux = 0.254
Uy = 0.254
Hsize = 300
Vsize = 300

# Generar coordenadas X, Y
xs = (Ux/2)*(2/Hsize)*(-Hsize/2:Hsize/2-1)
ys = (Uy/2)*(2/Vsize)*(-Vsize/2:Vsize/2-1)

# Generar malla de coordenadas usando producto externo
Xs = ones(length(xs)).*ones(length(xs))'
Ys = ones(length(xs)).*ones(length(ys))'
include("C:/Users/JayPC/LabO/Reto/meshgrid.jl")
Xs, Ys = meshgrid(xs,ys)

# Campo de interes
lambda = 633e-9
w0 = 5e-3

# Vector de propagacion
k=2*pi/lambda
thz = pi/6000
thxy = 0
kx = k*sin(thz)*cos(thxy)
ky = k*sin(thz)*sin(thxy)
kz = k*cos(thz)


# Modo Laguerre Gauss 
LG(X,Y,w0,m) = sqrt.(X.^2+Y.^2).^ abs(m) .* exp.(-(X.^2+Y.^2)/w0^2).*exp.(1im*(m*atan.(Y,X)))

U = exp(1im*(kx*Xs + ky*Ys)) .* LG(Xs,Ys,w0,1)
H = angle.(U)

heatmap(abs.(H))



# Gerchberg-Saxton
A = ifft(H)
for i = 1:500
    B = (1)*exp(1im*angle.(A))
    C = fft(B)
    D = abs(H) .* exp(1im*angle.(C))
    A = ifft(D)
end





