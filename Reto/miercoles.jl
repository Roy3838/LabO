using Plots
using LaTeXStrings
using Images
using DSP
using ImageFiltering

gr()
# --------------PARAMETERS------------#

height = 2801
width = 2551
gil_path = "C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Fotos_Miercoles_15/"
roy_path = "/Users/roymedina/LabO/pikas/Fotos_Viernes_10_2/"
IM_PATH = gil_path

# Crop parameters
x1_ref=200
x2_ref=3100
y1_ref=1050
y2_ref=3700

x1_im = x1_ref 
x2_im = x2_ref 
y1_im = y1_ref 
y2_im = y2_ref 

#--------------- PIXEL TO MM.---------------#
im1[1140:2010, 2090:2950]
mm = round(881/25.4)
a = 111
a = a/mm
ref1[800:950, 2120:2230]
ref1[x1_ref:x2_ref, y1_ref:y2_ref]
# -----------IMPORT IMAGES-----------#
ref1 = Float64.(Gray.(load(IM_PATH*"DSC_0468.JPG")))
#plot(Float64.(ref1[1632,2463:2545]))
ref2 = Float64.(Gray.(load(IM_PATH*"DSC_0469.JPG")))
ref3 = Float64.(Gray.(load(IM_PATH*"DSC_0470.JPG")))
ref4 = Float64.(Gray.(load(IM_PATH*"DSC_0471.JPG")))
# ---------IMPORT REFERENCES--------#

im1 = Gray.(load(IM_PATH*"DSC_0475.JPG"))
im2 = Float64.(Gray.(load(IM_PATH*"DSC_0474.JPG")))
im3 = Float64.(Gray.(load(IM_PATH*"DSC_0473.JPG")))
im4 = Float64.(Gray.(load(IM_PATH*"DSC_0472.JPG")))

# -----------CROP IMAGES------------#
include("crop.jl")
im1 = crop(im1,x1_im,x2_im,y1_im,y2_im)
im2 = crop(im2,x1_im,x2_im,y1_im,y2_im)
im3 = crop(im3,x1_im,x2_im,y1_im,y2_im)
im4 = crop(im4,x1_im,x2_im,y1_im,y2_im)
heatmap(im1)
# -----------CROP REFERENCES------------#
ref1 = crop(ref1,x1_ref,x2_ref,y1_ref,y2_ref)
ref2 = crop(ref2,x1_ref,x2_ref,y1_ref,y2_ref)
ref3 = crop(ref3,x1_ref,x2_ref,y1_ref,y2_ref)
ref4 = crop(ref4,x1_ref,x2_ref,y1_ref,y2_ref)

im1 = imresize(im1, (height, width))
im2 = imresize(im2, (height, width))
im3 = imresize(im3, (height, width))
im4 = imresize(im4, (height, width))

sze = 8

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

Φu1 = unwrap(Φs,dims = 1:2,range = 2pi)
Φu2 = unwrap(Φi,dims = 1:2,range = 2pi)
Φut = Φu1-Φu2
heatmap(w, h, Φu, aspect_ratio = :equal)

θ = atan(14.5/35)
Φu_n =  imfilter(Φu, Kernel.gaussian(10))
heatmap(w, h, Φu_n, xlims = (0, 75), ylims = (0, 82), aspect_ratio = :equal)

h = ((1:length(Φu_n[:,1])).-1)./mm
w = ((1:length(Φu_n[1,:])).-1)./mm

length(h)
length(w)
include("meshgrid.jl")

a/(2*pi*tan(θ))
z = Φu_n.*(a/(2*pi*tan(θ)))

u = surface(w, h, z,  xlims = (0, 75), ylims = (0,82),camera = (45,45), aspect_ratio = 1)
plot3d!([0, 75],[0,0],[0,0], lc = :black, legend = false)
plot3d!([0, 0],[0,82],[0,0], lc = :black, legend = false)
plot3d!([0, 0],[0,0],[0,75], lc = :black, legend = false, zlabel = "z (mm)")
xlabel!("x (mm)")
ylabel!("y (mm)")

save(u, "timon_isotropica.png")

