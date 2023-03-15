using Plots
using LaTeXStrings
using Images
using DSP
using ImageFiltering

# --------------PARAMETERS------------#

height = 2801
width = 2551
gil_path = "C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Fotos_Martes_14/"
roy_path = "/Users/roymedina/LabO/pikas/Fotos_Viernes_10_2/"
IM_PATH = gil_path

# Crop parameters
x1_ref=300
x2_ref=3100
y1_ref=1150
y2_ref=3700

x1_im = x1_ref 
x2_im = x2_ref 
y1_im = y1_ref 
y2_im = y2_ref 

#--------------- PIXEL TO MM.---------------#

mm = 36
a = 83
a = a/mm
# -----------IMPORT IMAGES-----------#
load(IM_PATH*"DSC_0355.JPG")
ref1 = Float64.(Gray.(load(IM_PATH*"DSC_0355.JPG")))
#ref1[300:700,2450:2550]
#plot(Float64.(ref1[1632,2463:2545]))
ref2 = Float64.(Gray.(load(IM_PATH*"DSC_0356.JPG")))
ref3 = Float64.(Gray.(load(IM_PATH*"DSC_0357.JPG")))
ref4 = Float64.(Gray.(load(IM_PATH*"DSC_0358.JPG")))
# ---------IMPORT REFERENCES--------#

im1 = Float64.(Gray.(load(IM_PATH*"DSC_0362.JPG")))
im2 = Float64.(Gray.(load(IM_PATH*"DSC_0361.JPG")))
im3 = Float64.(Gray.(load(IM_PATH*"DSC_0360.JPG")))
im4 = Float64.(Gray.(load(IM_PATH*"DSC_0359.JPG")))

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

sze = 5

include("noise_supp.jl")

im1_n = noise_supp(im1,sze)
im2_n = noise_supp(im2, sze)
im3_n = noise_supp(im3, sze)
im4_n = noise_supp(im4, sze)

ref1_n = noise_supp(ref1, sze)
ref2_n = noise_supp(ref2, sze)
ref3_n = noise_supp(ref3, sze)
ref4_n = noise_supp(ref4, sze)

#Crop lost information
crp = 450

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

θ = atan(11.5/31.8)
Φu_n =  imfilter(Φu, Kernel.gaussian(7))
heatmap(Φu_n)

h = ((1:length(Φu_n[:,1])).-1)./mm
w = ((1:length(Φu_n[1,:])).-1)./mm

length(h)
length(w)
include("meshgrid.jl")

z = Φu_n.*(a/(2*pi*tan(θ)))
heatmap(w, h, abs.(z),xlims = (10, 40), ylims = (5,35), aspect_ratio = :equal)
surface(w, h, z, zlims = (0,45),camera = (45,60), aspect_ratio = :equal)
surface(w, h, z, xlims = (10, 40), ylims = (5,35),camera = (0,90), aspect_ratio = :equal)

