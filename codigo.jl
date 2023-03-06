# Code to simulate the propagation of a LASER and retarding of the phase using \lambda/4 and \lambda/2 plates


# Defining Variables
N=2^7
w0 = 1
xmax = 4*w0
ymax = 4*w0
x = xmax*(2/N)*(-N/2:N/2-1)
y = ymax*(2/N)*(-N/2:N/2-1)
m = 1
Ex = zeros(Complex{Float64},N,N)
Ey = zeros(Complex{Float64},N,N)

# Defining the function E(r,phi) which indicates the electric field
function E(r,theta)
    E = (r/w0).^m*exp(-r.^2/w0.^2)*exp(im*m*theta)    
    return E
end

# Polarizing the electric field
function polarizador(Ex,Ey,theta)
    Jp_theta = [cos(theta)^2 sin(theta)*cos(theta);sin(theta)*cos(theta) sin(theta)^2]
    Ex_out = Jp_theta[1,1]*Ex + Jp_theta[1,2]*Ey
    Ey_out = Jp_theta[2,1]*Ex + Jp_theta[2,2]*Ey
    return Ex_out, Ey_out
end

# Retarder lambda/2 function
function retardador2(Ex,Ey,theta)
    Jp_theta = [cos(2*theta) sin(2*theta);sin(2*theta) -cos(2*theta)]
    Ex_out = Jp_theta[1,1]*Ex + Jp_theta[1,2]*Ey
    Ey_out = Jp_theta[2,1]*Ex + Jp_theta[2,2]*Ey
    return Ex_out, Ey_out
end

# Retarder lambda/4 function
function retardador4(Ex,Ey,theta)
    Jp_theta = [1 + im*cos(2*theta) im*sin(2*theta);im*sin(2*theta) 1 - im*cos(2*theta)]
    Ex_out = Jp_theta[1,1]*Ex + Jp_theta[1,2]*Ey
    Ey_out = Jp_theta[2,1]*Ex + Jp_theta[2,2]*Ey
    return Ex_out, Ey_out
end


# Return power of the electric field
function potencia(Ex,Ey)
    return sum(abs.(Ex).^2 + abs.(Ey).^2)
end


# Evaluating the electric field initial conditions
for i in 1:N
    for j in 1:N
        # Change from cartesian to polar coordinates
        r = sqrt(x[i]^2+y[j]^2)
        theta = atan(y[j],x[i])
        Ex[i,j] = E(r,theta)
        Ey[i,j] = E(r,theta)
    end
end


# Plotting the electric field abs(E^2)
using Plots

# Loop to see how power changes with polarization angle, to see Malus Law
powerog = zeros(180)
power_retardador = zeros(180)
power_polarizador = zeros(180)
for i in 1:180
    powerog[i] = potencia(Ex,Ey)
    Ex_out, Ey_out = retardador4(Ex,Ey,i*2*pi/180)
    power_retardador[i] = potencia(Ex_out,Ey_out)
    Ex_out, Ey_out = polarizador(Ex_out,Ey_out,i*2*pi/180)
    power_polarizador[i] = potencia(Ex_out,Ey_out)
end

# Plot power
plot(1:180,power_polarizador)
