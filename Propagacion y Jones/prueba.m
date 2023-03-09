lambda = 633e-9;
w0 = 0.5e-3;
N=512;
L = 20*w0;
dx = L/N;
NV = (-(N/2):(N/2-1));
xs = NV*dx;
ys = NV*dx;
[Xs, Ys] = meshgrid(xs, ys)



