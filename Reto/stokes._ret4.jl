using Plots
using LaTeXStrings
using Images
using DSP
using ImageFiltering
using Statistics

# --------------PARAMETERS------------#

height = 480
width = 640
h = 1:height
w = 1:width

gil_path = "C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Fotos_Mieroles_Stokes_polarizador/"
roy_path = "/Users/roymedina/LabO/pikas/Stokes/"
IM_PATH = gil_path


#--------------------IMPORT IMAGES -------------#

I0 = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_43_58_Pro_Polarizador_I0.jpg")))
Ix = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_37_30_Pro_Polarizador_Horizontal.jpg")))
Iy = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_37_56_Pro_Polarizador_Vertcal.jpg")))
Id = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_37_39_Pro_Polarizador_Diagonal.jpg")))
Ia = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_38_12_Pro_Polarizador_Antidiagonal.jpg")))
Ir = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_39_20_Pro_Polarizador_Derecha.jpg")))
Il = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_39_48_Pro_Polarizador_Izquierda.jpg")))
#---------------STOKES PARAMETERS----------------#

S0 = Iy + Ix
S1 = Ix - Iy
S2 = Ir - Il
S3 = Id - Ia

"S0 = 1
S1 = 0
S3 = 0
S2 = √(S0^2-S1^2-S3^2)"

#Number of polarization elpises

#----------------Crop-----------------
yc = 181:300
xc = 241:400
I0c = I0[yc,xc]
S0c = S0[yc,xc]
S1c = S1[yc,xc]
S2c = S2[yc,xc]
S3c = S3[yc,xc]

N = 8
heightc = length(I0c[:,1])
widthc = length(I0c[1,:])
wc = 1:widthc
hc = 1:heightc
#heatmap(wc, hc, I0c, c = :grays, )
plot(0,0)
for ii in range(1,Int(heightc/N))
    yr = Int(N/2)*ii
    for jj in range(1,Int(widthc/N))
        xr = Int(N/2)*jj


        S0_p = S0c[yr,xr]
        S1_p = S1c[yr,xr]
        S2_p = S2c[yr,xr]
        S3_p = S3c[yr,xr]

        χ = (1/2)*atan.(S3_p, S1_p)
        b = sqrt.((1 - atan.((S1_p.^2+S3_p.^2),S2_p.^2)./(pi/2))/2)
        a = sqrt(1 - b.^2)

        # Create a range of angles for plotting
        theta = range(0, stop=2*pi, length=100)

        # Calculate the x and y coordinates of the ellipse
        x = a*cos.(theta).*cos(χ) - b*sin.(theta).*sin(χ)
        y = a*cos.(theta).*sin(χ) + b*sin.(theta).*cos(χ)
        
        # Scale into square size (N*N) and positionate
        xs = (N/2).*x .+ 2*xr.-(N/2)
        ys = (N/2).*y.+ 2*yr.-(N/2)
        plot!(xs, ys, lc = :blue, lw = 2, label = false)
    end
end

plot!(0, 0, lc = :blue, lw = 2, label = false)

xlabel!("x")
ylabel!("y")

savefig(IM_PATH"Polarizacion_Exp.jpg")
