using Plots
using Images
using GLM
using DataFrames



# Import image fig1.jpeg
fig1 = Float64.(Gray.(load("/Users/roymedina/LabO/Mach-Zehnder/fig7.jpeg")))

# Take the cross section of the image
fig1_cross = fig1[300,:]

# Ni modo
# a = 1:1500
# a = a.*pi/300
# b = 0.9
# x = b.*cos.(0.9.*a .+ pi/2 .- 0.4).^2

a = 1:1500
a = a.*pi/300
b = 0.9
x = b.*cos.(10 .*a .+ pi/2 .- 0.4).^2



# Plot the cross section
plot(fig1_cross, label="Cross section of image")
plot!(x, label="Cos^2 fit")











