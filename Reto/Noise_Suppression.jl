using Images
using Plots
using FFTW
using StatsBase
using LaTeXStrings
#Import Image

img_path = "C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Fotos_jueves_9/DSC_0006_finas_ref.JPG"
img = load(img_path)

#GrayScale and chop to effective Image
gray_image = Gray.(img[800:2000,1500:3000])
gray_matrix = Float32.(gray_image)
gray_matrix = gray_matrix.-[minimum(gray_matrix)]
gray_matrix = gray_matrix./maximum(gray_matrix)

#Plot as a 3d Surface
ylen = length(gray_image[:,1]) 
xlen = length(gray_image[1,:])
x = -xlen/2:(xlen/2-1)
y = -ylen/2:(ylen/2-1)

"sze =2

noissupp = 1/(sze^2) * ones(2*sze+1,2*sze+1)
nois_mat = zeros(ylen,xlen)
for ii in range(sze+1, ylen-sze-1)
    for jj in range(sze+1, xlen-sze-1)
        nois_mat[ii, jj] = sum(noissupp.*gray_matrix[ii-sze:ii+sze, jj-sze:jj+sze])
    end
end
nois_mat = nois_mat./[maximum(nois_mat)]"

plot(x[sze+1:xlen-sze-1], y[sze+1:ylen-sze-1],
    gray_matrix[sze+1:ylen-sze-1,sze+1:xlen-sze-1], 
        st = :surface, camera = (0,90))
xut = x[sze+1:xlen-sze-1]
xlenut = length(xut)
transvcut = gray_matrix[600,sze+1:xlen-sze-1] 

# Decrease transvcut by 0.7
transvcutn = nois_mat[600,sze+1:xlen-sze-1]

transvcut = transvcut #xd 

plot(xut, transvcut, lc = :blue, lw = 4, size = (900, 600),  
gridalpha = 0.75, framestyle = :origin, label = L"S1", legendfont = font(14),
xtickfont = font(14), ytickfont = font(14), xlabel = L"x", ylabel = L"I", guidefontsize = 18)

aprox = 0.2*cos.([18*pi*1.61].*xut./[xlenut].-[0.50]).^2
# plot!(xut, aprox, lc = :red, ls = :dash, lw = 4, size = (900, 600),  
# gridalpha = 0.75, framestyle = :origin, label = L"cos^2(\omega x+\alpha)", legendfont = font(14),
# xtickfont = font(14), ytickfont = font(14))
savefig("Plots/graphS1.png")
