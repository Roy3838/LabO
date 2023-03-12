using DSP
using Plots
include("unwrap_chochado.jl")


# Make a meshgrid and a z plane with slope 1 in x and y direction
x = 1:100
y = 1:100
x_l, y_l = meshgrid(x, y)
z = x_l/5 + y_l/5

# wrap z values to [-pi, pi]
z = mod.(z, 2pi) .- pi


# unwrapping 
z = phase_unwrap(z)

# plot normal z
surface(z, camera=(30, 60))

# plot surface using plotlyjs()
# plotlyjs()
# surface(x_l, y_l, z, camera=(30, 60))




