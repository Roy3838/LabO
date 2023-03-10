using Plots, LaTeXStrings
using Images
using DSP

# --------------PARAMETERS------------#

height = 1800
width = 1700
IM_PATH = "C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Fotos_Viernes_10_2/"

# Crop parameters
x1_ref=1501
x2_ref=3300
y1_ref=2101
y2_ref=3800

x1_im = x1_ref - 60
x2_im = x2_ref 
y1_im = y1_ref + 75
y2_im = y2_ref + 150

# -----------IMPORT IMAGES-----------#
ref1 = Float64.(Gray.(load(IM_PATH*"DSC_0026.JPG")))
ref2 = Float64.(Gray.(load(IM_PATH*"DSC_0027.JPG")))
ref3 = Float64.(Gray.(load(IM_PATH*"DSC_0028.JPG")))
ref4 = Float64.(Gray.(load(IM_PATH*"DSC_0029.JPG")))

# ---------IMPORT REFERENCES--------#

im1 = Float64.(Gray.(load(IM_PATH*"DSC_0033.JPG")))
im2 = Float64.(Gray.(load(IM_PATH*"DSC_0032.JPG")))
im3 = Float64.(Gray.(load(IM_PATH*"DSC_0031.JPG")))
im4 = Float64.(Gray.(load(IM_PATH*"DSC_0030.JPG")))

# -----------CROP IMAGES------------#
include("crop.jl")
im1 = crop(im1,x1_im,x2_im,y1_im,y2_im)
im2 = crop(im2,x1_im,x2_im,y1_im,y2_im)
im3 = crop(im3,x1_im,x2_im,y1_im,y2_im)
im4 = crop(im4,x1_im,x2_im,y1_im,y2_im)

# -----------CROP REFERENCES------------#
ref1 = crop(ref1,x1_ref,x2_ref,y1_ref,y2_ref)
ref2 = crop(ref2,x1_ref,x2_ref,y1_ref,y2_ref)
ref3 = crop(ref3,x1_ref,x2_ref,y1_ref,y2_ref)
ref4 = crop(ref4,x1_ref,x2_ref,y1_ref,y2_ref)

im1 = imresize(im1, (height, width))
im2 = imresize(im2, (height, width))
im3 = imresize(im3, (height, width))
im4 = imresize(im4, (height, width))

# ------------NOISE SUPPRESSION----------#
function noise_supp(img::Array{Float64,2}, sze::Int)::Array{Float64,2}

    noissupp = 1/(sze^2) * ones(2*sze+1,2*sze+1)
    nois_mat = zeros(height, width)

    for ii in range(sze+1, height-sze-1)
        for jj in range(sze+1, width-sze-1)
            nois_mat[ii, jj] = sum(noissupp.*img[ii-sze:ii+sze, jj-sze:jj+sze])
        end
    end

    return nois_mat

end

sze = 4

im1_n = noise_supp(im1, 4)
im2_n = noise_supp(im2, 4)
im3_n = noise_supp(im3, 4)
im4_n = noise_supp(im4, 4)

ref1_n = noise_supp(ref1, 4)
ref2_n = noise_supp(ref2, 4)
ref3_n = noise_supp(ref3, 4)
ref4_n = noise_supp(ref4, 4)

Φi = atan.(im2_n-im4_n,im1_n-im3_n)

Φs = atan.(ref2_n-ref4_n,ref1_n-ref3_n)

Φu = unwrap(Φs-Φi,dims = 1:2,range = 2pi)

heatmap(Φu)

θ = atan(18/39.5)

y = 1:height
x = 1:width

Φu_n = noise_supp(Φu, sze)
plot(x, y, -Φu_n, st = :surface, camera = (0,60))











