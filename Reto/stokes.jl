using Plots
using LaTeXStrings
using Images
using DSP
using ImageFiltering

# --------------PARAMETERS------------#

height = 2048
width = 2048
h = 1:height
w = 1:width

gil_path = "C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Stokes/"
roy_path = "/Users/roymedina/LabO/pikas/Stokes/"
IM_PATH = gil_path


#--------------------IMPORT IMAGES -------------#
I0 = Float64.()
Ix = Float64.()
Iy = Float64.()
Id = Float64.()
Ia = Float64.()
Ir = Float64.()
Il = Float64.()
#---------------STOKES PARAMETERS----------------#

S0 = Iy + Ix
S1 = Ix - Iy
S2 = Ir - Il
S3 = Id - Ia

S0 = 1
S1 = 0
S3 = 0
S2 = √(S0^2-S1^2-S3^2)

#Number of polarization elpises

N = 2^4
heatmap(w, h, I0, colormap = :grays)

for ii in range(1,Int(height/N))
    yr = N*ii-(N-1):N*ii
    for jj in range(1,Int(width/N))
        xr = N*jj-(N-1):N*jj


        S0_p = mean(S0[yr,xr])
        S1_p = mean(S1[yr,xr])
        S2_p = mean(S2[yr,xr])
        S3_p = mean(S3[yr,xr])

        χ = (1/2)*atan.(S3_p, S1_p)
        b = sqrt.((1 - atan.((S1_p.^2+S3_p.^2),S2_p.^2)./(pi/2))/2)
        a = sqrt(1 - b.^2)

        # Create a range of angles for plotting
        theta = range(0, stop=2*pi, length=100)

        # Calculate the x and y coordinates of the ellipse
        x = a*cos.(theta).*cos(χ) - b*sin.(theta).*sin(χ)
        y = a*cos.(theta).*sin(χ) + b*sin.(theta).*cos(χ)
        
        # Scale into square size (N*N) and positionate
        xs = (N/2).*x .+ xr[Integer(round(end/2))]
        ys = (N/2).*y.+ yr[Integer(round(end/2))]
        plot!(xs, ys, lc = :blue, lw = 2, label = false)
    end
end
plot!(xs, ys, lc = :blue, lw = 2, label = false)

xlabel!("x")
ylabel!("y")



