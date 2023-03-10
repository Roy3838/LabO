using Images
using Plots
using FFTW
using StatsBase
using LaTeXStrings
using DSP 

#Import Images
ref_path_0 = load("C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Fotos_jueves_9/DSC_0006_finas_ref.JPG")
img_path_0 = load("C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Fotos_Viernes_10_2/DSC_0026.JPG")

ref_path_0[470:2450,1500:3000]
#GrayScale and chop to effective Image
gray_ref_0 = Gray.(ref_path_0[500:2000,1500:3000])
matrix_ref_0 = Float32.(gray_ref_0)
matrix_ref_0 = matrix_ref_0.-[minimum(matrix_ref_0)]
matrix_ref_0 = matrix_ref_0./maximum(matrix_ref_0)

gray_img_0 = Gray.(img_path_0[1500:3300,2000:3800])
matrix_img_0 = Float32.(gray_img_0)
matrix_img_0 = matrix_img_0.-[minimum(matrix_img_0)]
matrix_img_0 = matrix_img_0./maximum(matrix_img_0)

xlen = length(matrix_img_0[1050,:])
ylen = length(matrix_img_0[:,1])

x = 1:xlen
y = 1:ylen
plot(x, matrix_img_0[1050,:])
matrix_img_0[1050,:]
sze = 4

noissupp = 1/(sze^2) * ones(2*sze+1,2*sze+1)
nois_mat = zeros(ylen,xlen)
for ii in range(sze+1, ylen-sze-1)
    for jj in range(sze+1, xlen-sze-1)
        nois_mat[ii, jj] = sum(noissupp.*matrix_img_0[ii-sze:ii+sze, jj-sze:jj+sze])
    end
end
nois_mat = nois_mat./[maximum(nois_mat)]

plot(x[sze+1:xlen-sze-1], y[sze+1:ylen-sze-1],
    gray_matrix[sze+1:ylen-sze-1,sze+1:xlen-sze-1], 
        st = :surface, camera = (0,90))
xut = x[sze+1:xlen-sze-1]
xlenut = length(xut)
transvcut = nois_mat[1050,sze+1:xlen-sze-1] 

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
