using Plots, LaTeXStrings
using Images
using DSP



# --------------PARAMETERS------------#


height = 1024
width = 1280
IM_PATH = "C:/Users/JayPC/LabO/pikas/Fotos_jueves_9/"

# Crop parameters
x1=301
x2=650
y1=501
y2=800


# -----------IMPORT IMAGES-----------#
im1load = load(IM_PATH*"DSC_0002_finas _0.JPG")
im2load = load(IM_PATH*"DSC_0003_finas_45.JPG")
im3load = load(IM_PATH*"DSC_0004_finas_90.JPG")
im4load = load(IM_PATH*"DSC_0005_finas_135.JPG")


im1 = imresize(im1load,(height,width))
im2 = imresize(im2load,(height,width))
im3 = imresize(im3load,(height,width))
im4 = imresize(im4load,(height,width))

# ---------IMPORT REFERENCES--------#

# simon por mientras cuchareada

function cuchareada(Matrix)
    cropsito = Matrix[1:50,:]
    # mirror in vertical axis
    cropsitomirror = cropsito[end:-1:1,:]
    # concatenate cropsitos
    cropsitot = vcat(cropsito, cropsitomirror)
    cropsitot = vcat(cropsitot, cropsito)
    cropsitot = vcat(cropsitot, cropsitomirror)
    cropsitot = vcat(cropsitot, cropsito)
    cropsitot = vcat(cropsitot, cropsitomirror)
    cropsitot = vcat(cropsitot, cropsito)
    return cropsitot
end



# -----------CROP IMAGES------------#
include("crop.jl")
im1 = crop(im1,x1,x2,y1,y2)
im2 = crop(im2,x1,x2,y1,y2)
im3 = crop(im3,x1,x2,y1,y2)
im4 = crop(im4,x1,x2,y1,y2)

# -----------CROP REFERENCES------------#
ref1 = cuchareada(im1)
ref2 = cuchareada(im2)
ref3 = cuchareada(im3)
ref4 = cuchareada(im4)
ref1 = crop(ref1,x1,x2,y1,y2)
ref2 = crop(ref2,x1,x2,y1,y2)
ref3 = crop(ref3,x1,x2,y1,y2)
ref4 = crop(ref4,x1,x2,y1,y2)

# -----------DATA PROCESSING------------#
im1 = float.(im1)
im2 = float.(im2)
im3 = float.(im3)
im4 = float.(im4)
ref1 = float.(ref1)
ref2 = float.(ref2)
ref3 = float.(ref3)
ref4 = float.(ref4)

Φi = atan.(im2-im4,im1-im3)

Φs = atan.(ref2-ref4,ref1-ref3)

Φu = unwrap(Φs-Φi,dims = 1:2,range = 2pi)

θ = atan(18/50)

α = deg2rad(0)  









