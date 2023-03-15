using Plots, LaTeXStrings
using Images
using DSP

# --------------PARAMETERS------------#

height = 1000
width = 1000
IM_PATH = "/Users/roymedina/LabO/pikas/Karla/"

# Crop parameters
y1_ref=1800
y2_ref=2800
x1_ref=1000
x2_ref=2000

x1_im = x1_ref  
x2_im = x2_ref 
y1_im = y1_ref   
y2_im = y2_ref

# -----------IMPORT IMAGES-----------#
ref1 = Float64.(Gray.(load(IM_PATH*"Referencia 1.JPG")))
ref2 = Float64.(Gray.(load(IM_PATH*"Referencia 2.JPG")))
ref3 = Float64.(Gray.(load(IM_PATH*"Referencia 3.JPG")))
ref4 = Float64.(Gray.(load(IM_PATH*"Referencia 4.JPG")))

# ---------IMPORT REFERENCES--------#

im1 = Float64.(Gray.(load(IM_PATH*"Franjas 1.JPG")))
im2 = Float64.(Gray.(load(IM_PATH*"Franjas 2.JPG")))
im3 = Float64.(Gray.(load(IM_PATH*"Franjas 3.JPG")))
im4 = Float64.(Gray.(load(IM_PATH*"Franjas 4.JPG")))


# # -----------CROP IMAGES------------#
include("crop.jl")
im1 = crop(im1,x1_im,x2_im,y1_im,y2_im)
im2 = crop(im2,x1_im,x2_im,y1_im,y2_im)
im3 = crop(im3,x1_im,x2_im,y1_im,y2_im)
im4 = crop(im4,x1_im,x2_im,y1_im,y2_im)

# # -----------CROP REFERENCES------------#
ref1 = crop(ref1,x1_ref,x2_ref,y1_ref,y2_ref)
ref2 = crop(ref2,x1_ref,x2_ref,y1_ref,y2_ref)
ref3 = crop(ref3,x1_ref,x2_ref,y1_ref,y2_ref)
ref4 = crop(ref4,x1_ref,x2_ref,y1_ref,y2_ref)

# im1 = imresize(im1, (height, width))
# im2 = imresize(im2, (height, width))
# im3 = imresize(im3, (height, width))
# im4 = imresize(im4, (height, width))

include("noise_supp.jl")


sze = 3

im1_n = noise_supp(im1,sze)
im2_n = noise_supp(im2, sze)
im3_n = noise_supp(im3, sze)
im4_n = noise_supp(im4, sze)

ref1_n = noise_supp(ref1, sze)
ref2_n = noise_supp(ref2, sze)
ref3_n = noise_supp(ref3, sze)
ref4_n = noise_supp(ref4, sze)

heatmap(im1_n)

#Crop lost information


Φi = atan.(-im2_n+im4_n,im1_n-im3_n)

Φs = atan.(-ref2_n+ref4_n,ref1_n-ref3_n)

include("unwrap_chochado.jl")

Φu = Φs-Φi

#Φu = unwrap(Φu,dims = 1:2,range = 2pi)

#heatmap(Φu)

psi = Φu

dx = [zeros(size(psi,1),1) wrapToPi(diff(psi, dims=2)) zeros(size(psi,1),1)]
dy = [zeros(1,size(psi,2)); wrapToPi(diff(psi, dims=1)); zeros(1,size(psi,2))]
rho = diff(dx,dims=2) + diff(dy,dims=1)
# solve the poisson equation using dct in 2 dimensions
dctRho = mapslices(dct, rho, dims=(1,2))
#dctRho = mapslices(dct, dctRho, dims=(2,1))
# print(dctRho)
N, M = size(rho)
I = ones(N,1).*ones(1,M)
J = ones(M,1).*ones(1,N)

dctPhi = dctRho ./ 2 ./ (cos(pi*I/M) + cos(pi*J/N) .- 2)
dctPhi[1,1] = 0 # handling the inf/nan value
phi = mapslices(idct, dctPhi, dims=(1,2))

# Φu = unwrap(Φu, dims = 1:2,range = 2pi)

plotlyjs()
surface(phi, color = :thermal, showaxis = false, camera = (30, 30), title = "Phase")


# # θ = atan(18/39.5)

# # Φu_n = noise_supp(Φu, 2)
# # h = 1:length(Φu_n[:,1])
# # w = 1:length(Φu_n[1,:])

# # # -------------------MESHGRID FUNCTION------------------#
# # function meshgrid(xin,yin)
# #     nx=length(xin)
# #     ny=length(yin)
# #     xout=zeros(ny,nx)
# #     yout=zeros(ny,nx)
# #     for jx=1:nx
# #         for ix=1:ny
# #             xout[ix,jx]=xin[jx]
# #             yout[ix,jx]=yin[ix]
# #         end
# #     end
# #     return (x=xout, y=yout)
# # end
# # x_l, y_l = meshgrid(w, h)

# # surface(w, h, abs.(Φu_n))






