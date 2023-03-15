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
z = 10;

# Vector de propagacion
k = 2*pi/lambda
thz = pi/6000
thxy = 0
kx = k*sin(thz)*cos(thxy)
ky = k*sin(thz)*sin(thxy)
kz = k*cos(thz)

#Campos a interferir 
E0 = 1;
E1 = E0.*exp.(1im.*(kx.*Xs .+ ky.*Ys .+ kz.*z)).*[[1; 0]]
E2 = E0.*exp.(1im.*(-kx.*Xs .+ ky.*Ys .+ kz.*z)).*[[0; 1]]
Et = E1 + E2

#Visualizamos el campo y su polarización
heatmap(norm.(Et).^2,clim = (0,2), label = false, c = :grays)

N = 8
for ii in range(1,Int(Ntot/N))
    yr = N*ii-(N-1):N*ii
    for jj in range(1,Int(Ntot/N))
        xr = N*jj-(N-1):N*jj

        prom = mean(Et[yr, xr])
        Ix = norm.([1 0]*prom).^2
        Iy = norm.([0 1]*prom).^2
        Ir = norm.([1 1im]*prom).^2
        Il = norm.([1 -1im]*prom).^2
        Id = norm.([1 1]*prom).^2
        Ia = norm.([1 -1]*prom).^2

        S0_p = Ix[1] + Iy[1]
        S1_p = Ix[1] - Iy[1]
        S2_p = Ir[1] - Il[1]
        S3_p = Id[1] - Ia[1]

        χ = (1/2)*atan.(S3_p, S1_p)
        b = sqrt.((1 - atan.((S1_p.^2+S3_p.^2),S2_p.^2)./(pi/2))/2)
        a = sqrt(1 - b.^2)

        # Create a range of angles for plotting
        theta = range(0, stop=2*pi, length=50)

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
#Agregamos retardador de cuarto de onda

function retλ4(θ)
    rλ4 = (1/√2)*[1+1im*cos(2*θ) im*sin(2*θ);
        im*sin(2*θ) 1-im*cos(2*θ)];
    return rλ4
end;
Interf = retλ4(pi/4)
Etr4 = [Interf].*Et
heatmap((norm.(Etr4).^2), clim = (0,2), c = :grays)

N = 8
for ii in range(1,Int(Ntot/N))
    yr = N*ii-(N-1):N*ii
    for jj in range(1,Int(Ntot/N))
        xr = N*jj-(N-1):N*jj

        prom = mean(Etr4[yr, xr])
        Ix = norm.([1 0]*prom).^2
        Iy = norm.([0 1]*prom).^2
        Ir = norm.([1 1im]*prom).^2
        Il = norm.([1 -1im]*prom).^2
        Id = norm.([1 1]*prom).^2
        Ia = norm.([1 -1]*prom).^2

        S0_p = Ix[1] + Iy[1]
        S1_p = Ix[1] - Iy[1]
        S2_p = Ir[1] - Il[1]
        S3_p = Id[1] - Ia[1]

        χ = (1/2)*atan.(S3_p, S1_p)
        b = sqrt.((1 - atan.((S1_p.^2+S3_p.^2),S2_p.^2)./(pi/2))/2)
        a = sqrt(1 - b.^2)

        # Create a range of angles for plotting
        theta = range(0, stop=2*pi, length=50)

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
for ii in range(1,Int(Ntot/N))
    yr = N*ii-(N-1):N*ii
    for jj in range(1,Int(Ntot/N))
        xr = N*jj-(N-1):N*jj

        prom = mean(Etfin[yr, xr])
        Ix = norm.([1 0]*prom).^2
        Iy = norm.([0 1]*prom).^2
        Ir = norm.([1 1im]*prom).^2
        Il = norm.([1 -1im]*prom).^2
        Id = norm.([1 1]*prom).^2
        Ia = norm.([1 -1]*prom).^2

        S0_p = Ix[1] + Iy[1]
        S1_p = Ix[1] - Iy[1]
        S2_p = Ir[1] - Il[1]
        S3_p = Id[1] - Ia[1]

        χ = (1/2)*atan.(S3_p, S1_p)
        b = sqrt.((1 - atan.((S1_p.^2+S3_p.^2),S2_p.^2)./(pi/2))/2)
        a = sqrt(1 - b.^2)

        # Create a range of angles for plotting
        theta = range(0, stop=2*pi, length=50)

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
