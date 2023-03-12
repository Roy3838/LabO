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

x1_im = x1_ref 
x2_im = x2_ref 
y1_im = y1_ref-14
y2_im = y2_ref+20

# -----------IMPORT IMAGES-----------#

ref1 = Float64.(Gray.(load(IM_PATH*"DSC_0057.JPG")))
ref2 = Float64.(Gray.(load(IM_PATH*"DSC_0056.JPG")))
ref3 = Float64.(Gray.(load(IM_PATH*"DSC_0055.JPG")))
ref4 = Float64.(Gray.(load(IM_PATH*"DSC_0054.JPG")))

# ---------IMPORT REFERENCES--------#

im1 = Float64.(Gray.(load(IM_PATH*"DSC_0050.JPG")))
im2 = Float64.(Gray.(load(IM_PATH*"DSC_0051.JPG")))
im3 = Float64.(Gray.(load(IM_PATH*"DSC_0052.JPG")))
im4 = Float64.(Gray.(load(IM_PATH*"DSC_0053.JPG")))

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

    noissupp = 1/((2*sze+1)^2) * ones(2*sze+1,2*sze+1)
    h = length(img[:,1])
    w = length(img[1,:])
    nois_mat = zeros(h,w)

    for ii in range(sze+1, h-sze-1)
        for jj in range(sze+1, w-sze-1)
            nois_mat[ii, jj] = sum(noissupp.*img[ii-sze:ii+sze, jj-sze:jj+sze])
        end
    end

    return nois_mat

end

sze = 3

im1_n = noise_supp(im1,sze)
im2_n = noise_supp(im2, sze)
im3_n = noise_supp(im3, sze)
im4_n = noise_supp(im4, sze)

ref1_n = noise_supp(ref1, sze)
ref2_n = noise_supp(ref2, sze)
ref3_n = noise_supp(ref3, sze)
ref4_n = noise_supp(ref4, sze)

#Crop lost information
crp = 100
heatmap(im1_n)  
heatmap(ref1_n)
im1_n = im1_n[crp:end-crp, crp:end-crp]
im2_n = im2_n[crp:end-crp, crp:end-crp]
im3_n = im3_n[crp:end-crp, crp:end-crp]
im4_n = im4_n[crp:end-crp, crp:end-crp]

ref1_n = ref1_n[crp:end-crp, crp:end-crp]
ref2_n = ref2_n[crp:end-crp, crp:end-crp]
ref3_n = ref3_n[crp:end-crp, crp:end-crp]
ref4_n = ref4_n[crp:end-crp, crp:end-crp]

Φi = atan.(-im2_n+im4_n,im1_n-im3_n)

Φs = atan.(-ref2_n+ref4_n,ref1_n-ref3_n)

Φu = unwrap(Φs-Φi,dims = 1:2,range = 2pi)
heatmap(Φu)
θ = atan(18/39.5)

Φu_n = noise_supp(Φu, 10)
h = 1:length(Φu_n[:,1])
w = 1:length(Φu_n[1,:])

# -------------------MESHGRID FUNCTION------------------#
function meshgrid(xin,yin)
    nx=length(xin)
    ny=length(yin)
    xout=zeros(ny,nx)
    yout=zeros(ny,nx)
    for jx=1:nx
        for ix=1:ny
            xout[ix,jx]=xin[jx]
            yout[ix,jx]=yin[ix]
        end
    end
    return (x=xout, y=yout)
end
x_l, y_l = meshgrid(w, h)

surface(w, h, Φu_n, camera = (45, 65))