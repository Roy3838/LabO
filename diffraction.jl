# Difraccion coso Benjas simon



N = 2^8
w0 = 1.0
xmax = 4*w0

xs = xmax*(2/N)*collect(0:N-1) - xmax
ys = xs
[X,Y] = meshgrid(xs,ys)

# Apertura circular 
circulo = (X.^2 + Y.^2) .< w0^2

# Graficar apertura
imshow(circulo, cmap="gray", extent=[-xmax, xmax, -xmax, xmax])2



