using Plots

# Campo de interes
lambda = 633e-9
ω0 = 5e-3

# Generar coordenadas X, Y
Ntot = 2^8
xmax = 2*ω0
ymax = xmax


xs = xmax*(2/Ntot)*(-Ntot/2:Ntot/2-1)
ys = ymax*(2/Ntot)*(-Ntot/2:Ntot/2-1)

# Generar malla de coordenadas usando producto externo
#Meshgrid
Ys = -ones(length(xs)).*xs*ones(length(xs))'
Xs = -Ys'
z = 1;

# Vector de propagacion
k = 2*pi/lambda
thz = pi/40000
thxy = 0
kx = k*sin(thz)*cos(thxy)
ky = k*sin(thz)*sin(thxy)
kz = k*cos(thz)

#Campos a interferir 
E0 = 1;
E1 = E0.*exp.(1im.*(kx.*Xs .+ ky.*Ys .+ kz.*z)).*[[1; 0]]
E2 = E0.*exp.(1im.*(-kx.*Xs .+ ky.*Ys .+ kz.*z)).*[[0; 1]]
Et = E1 + E2

yc = 1:120
xc = 1:160
Etc = Et[yc,xc]
#Visualizamos el campo y su polarización
N = 8
heightc = length(Etc[:,1])
widthc = length(Etc[1,:])
wc = 1:widthc
hc = 1:heightc
#heatmap(wc, hc, I0c, c = :grays, )
elp = palette([:red, :blue], 201);
heatmap(norm.(Etc).^2, c = :gray, clim = (0,2))
prom

prom = Etc
Ix = norm.([[1 0]].*prom).^2
Iy = norm.([[0 1]].*prom).^2
Ir = norm.([[1 1im]].*prom).^2
Il = norm.([[1 -1im]].*prom).^2
Id = norm.([[1 1]].*prom).^2
Ia = norm.([[1 -1]].*prom).^2
maxS2 = maximum(Ir-Il)

for ii in range(1,Int(heightc/N))
    yr = Int(N/2)*ii
    for jj in range(1,Int(widthc/N))
        xr = Int(N/2)*jj

        S0_p = Ix[yr, xr] + Iy[yr, xr]
        S1_p = Ix[yr, xr] - Iy[yr, xr]
        S2_p = Ir[yr, xr] - Il[yr, xr]
        S3_p = Id[yr, xr] - Ia[yr, xr]

        clr = Int(round(round(S2_p/maxS2, digits = 2)*100+101))
        χ = (1/2)*atan.(S3_p, S1_p)
        b = sqrt.((1 - atan.((S1_p.^2+S3_p.^2),S2_p.^2)./(pi/2))/2)
        a = sqrt(1 - b.^2)

        # Create a range of angles for plotting
        theta = range(0, stop=2*pi, length=50)

        # Calculate the x and y coordinates of the ellipse
        x = a*cos.(theta).*cos(χ) - b*sin.(theta).*sin(χ)
        y = a*cos.(theta).*sin(χ) + b*sin.(theta).*cos(χ)
        
        # Scale into square size (N*N) and positionate
        xs = (N/2).*x .+ 2*xr.-(N/2)
        ys = (N/2).*y.+ 2*yr.-(N/2)
        plot!(xs, ys, lc = elp[clr], lw = 2, label = false)
    end
end
plot!(xs, ys, lc = :blue, lw = 2, label = false)
#Agregamos retardador de cuarto de onda

function retλ4(θ)
    rλ4 = (1/√2)*[1+1im*cos(2*θ) im*sin(2*θ);
        im*sin(2*θ) 1-im*cos(2*θ)];
    return rλ4
end;
Interf = retλ4(pi/4)
Etr4 = [Interf].*Etc
heatmap((norm.(Etr4).^2), clim = (0,2), c = :grays)

N = 8

prom = Etr4
Ix = norm.([[1 0]].*prom).^2
Iy = norm.([[0 1]].*prom).^2
Ir = norm.([[1 1im]].*prom).^2
Il = norm.([[1 -1im]].*prom).^2
Id = norm.([[1 1]].*prom).^2
Ia = norm.([[1 -1]].*prom).^2
maxS2 = maximum(Ir-Il)
for ii in range(1,Int(heightc/N))
    yr = Int(N/2)*ii
    for jj in range(1,Int(widthc/N))
        xr = Int(N/2)*jj

        S0_p = Ix[yr, xr] + Iy[yr, xr]
        S1_p = Ix[yr, xr] - Iy[yr, xr]
        S2_p = Ir[yr, xr] - Il[yr, xr]
        S3_p = Id[yr, xr] - Ia[yr, xr]
        clr = 101
        χ = (1/2)*atan.(S3_p, S1_p)
        b = sqrt.((1 - atan.((S1_p.^2+S3_p.^2),S2_p.^2)./(pi/2))/2)
        a = sqrt(1 - b.^2)

        # Create a range of angles for plotting
        theta = range(0, stop=2*pi, length=50)

        # Calculate the x and y coordinates of the ellipse
        x = a*cos.(theta).*cos(χ) - b*sin.(theta).*sin(χ)
        y = a*cos.(theta).*sin(χ) + b*sin.(theta).*cos(χ)
        
        # Scale into square size (N*N) and positionate
        xs = (N/2).*x .+ 2*xr.-(N/2)
        ys = (N/2).*y.+ 2*yr.-(N/2)
        plot!(xs, ys, lc = elp[clr], lw = 2, label = false)
    end
end
plot!(xs, ys, lc = :blue, lw = 2, label = false)

#Agregamos el polarizador lineal
function Jpol(θ)
    J = [cos(θ)^2 sin(θ)*cos(θ);
    sin(θ)*cos(θ) sin(θ)^2];
    
    return J
end;
Interfpol = Jpol(pi/2)
Etfin = [Interfpol].*Etr4
heatmap((norm.(Etfin).^2), c = :grays)
N = 8
prom = Etfin
Ix = norm.([[1 0]].*prom).^2
Iy = norm.([[0 1]].*prom).^2
Ir = norm.([[1 1im]].*prom).^2
Il = norm.([[1 -1im]].*prom).^2
Id = norm.([[1 1]].*prom).^2
Ia = norm.([[1 -1]].*prom).^2
maxS2 = maximum(Ir-Il)
for ii in range(1,Int(heightc/N))
    yr = Int(N/2)*ii
    for jj in range(1,Int(widthc/N))
        xr = Int(N/2)*jj

        S0_p = Ix[yr, xr] + Iy[yr, xr]
        S1_p = Ix[yr, xr] - Iy[yr, xr]
        S2_p = Ir[yr, xr] - Il[yr, xr]
        S3_p = Id[yr, xr] - Ia[yr, xr]
        clr = 101
        χ = (1/2)*atan.(S3_p, S1_p)
        b = sqrt.((1 - atan.((S1_p.^2+S3_p.^2),S2_p.^2)./(pi/2))/2)
        a = sqrt(1 - b.^2)

        # Create a range of angles for plotting
        theta = range(0, stop=2*pi, length=50)

        # Calculate the x and y coordinates of the ellipse
        x = a*cos.(theta).*cos(χ) - b*sin.(theta).*sin(χ)
        y = a*cos.(theta).*sin(χ) + b*sin.(theta).*cos(χ)
        
        # Scale into square size (N*N) and positionate
        xs = (N/2).*x .+ 2*xr.-(N/2)
        ys = (N/2).*y.+ 2*yr.-(N/2)
        plot!(xs, ys, lc = elp[clr], lw = 2, label = false)
    end
end
plot!(xs, ys, lc = :blue, lw = 2, label = false)
