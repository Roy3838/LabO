using Images
using Plots
using FFTW
using StatsBase
using LaTeXStrings
using DSP


# Make a cos^2 matrix with the same size as the image
nsize = 500
x = -nsize/2:(nsize/2-1)
y = -nsize/2:(nsize/2-1)
sze = 5

# cos^2 array
arr = 0.2*cos.([18*pi*1.61].*x./[nsize].-[0.50]).^2
arr = arr'.*ones(nsize, nsize)

# Unwrapp the array using DSP
arr = unwrap(arr, dims=2)

# Plot cos^2 array as heatmap
heatmap(x, y, arr, size = (900, 600), gridalpha = 0.75, framestyle = :origin, 
    label = L"cos^2(\omega x+\alpha)", legendfont = font(14), xtickfont = font(14), 
    ytickfont = font(14), xlabel = L"x", ylabel = L"y", guidefontsize = 18)




