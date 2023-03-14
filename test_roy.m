x = 1:100;
y = 1:100;
[x_l, y_l] = meshgrid(x, y);
z = x_l/5 + y_l/5;

z = mod(z, 2*pi) - pi;

z = phase_unwrap(z);

surf(x_l, y_l, z)