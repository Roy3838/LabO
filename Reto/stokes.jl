using Plots
using LaTeXStrings
using Images
using DSP
using ImageFiltering
using Statistics

# --------------PARAMETERS------------#
plotly()
height = 480
width = 640
h = 1:height
w = 1:width

gil_path = "C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Fotos_Miercoles_Stokes/"
roy_path = "/Users/roymedina/LabO/pikas/Stokes/"
IM_PATH = gil_path


#--------------------IMPORT IMAGES -------------#

I0 = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_25_49_Pro_I0.jpg")))
Ix = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_11_07_Pro_Horizontal.jpg")))
Iy = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_11_56_Pro_Vertical.jpg")))
Id = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_11_37_Pro_Diagonal.jpg")))
Ia = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_12_12_Pro_Antidiagonal.jpg")))
Ir = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_15_41_Pro_Derecha.jpg")))
Il = Float64.(Gray.(load(IM_PATH*"WIN_20230315_09_16_04_Pro_Izquierda.jpg")))

sze = 4

include("noise_supp.jl")

im1_n = noise_supp(Ir,sze)
plot(im1_n[241,:], lc = :blue, lw = 2, label = "Experimental")
x = (1:640).*(2*pi/640)
y = cos.(7*x.+pi/4).^2
plot!(1:640,y, lc = :red, lw = 2, ls = :dash,label = "Analítico")
ylabel!(L"I\;(W/m^2)")
xlabel!(L"x\;(px)")
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
elp = palette([:red, :blue], 3);
heatmap(0, c = elp)
sign(0)
for ii in range(1,Int(heightc/N))
    yr = Int(N/2)*ii
    for jj in range(1,Int(widthc/N))
        xr = Int(N/2)*jj

        S0_p = S0c[yr,xr]
        S1_p = S1c[yr,xr]
        S2_p = S2c[yr,xr]
        S3_p = S3c[yr,xr]

        clr = Int((sign(S2_p))+2)
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
        plot!(xs, ys, lc = elp[clr], lw = 2, label = false)
    end
end

plot!(0, 0, lc = :blue, lw = 2, label = false, color= elp )
cbar = colorbar!()

xlabel!("x")
ylabel!("y")

savefig(IM_PATH"Polarizacion_Exp.jpg")

using Plots
using ColorSchemes

# Create some sample data
x = 1:10
y = rand(10, 5)

# Plot the data with different colors
p = plot(x, y, color=[:blue :red :green :orange :purple], linewidth=2, label=["A" "B" "C" "D" "E"])

# Add a colorbar to the plot
cbar = Colorbar(p, label="Legend")

