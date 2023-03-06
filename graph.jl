function I_1(theta, phi)
    I_0 = 1
    # d = 0.05mm cambia lo largo
    d = 0.00005
    # lambda = 0.000632 mm
    lambda = 0.000000632
    # a = 1mm cambia el periodo 
    a = 0.001

    d_angle = sin(theta)-sin(phi)
    term1 = sin(pi * d / lambda * (d_angle))
    term2 = pi*d/lambda*(d_angle)
    term3 = cos(pi * a / lambda * (d_angle))

    return I_0*((term1)/(term2))^2 * (term3)^2
end

function I_1_int(theta,phi)
    I_1_ints = zeros(length(theta))
    for i in 1:lastindex(theta)
        I_1_ints[i] = I_1(theta[i],phi)
    end
    return sum(I_1_ints)
end

using Plots
theta = range(-pi/100, stop=pi/100, length=1000)

# for s = 1
s = 1
z = 9000
phi = asin(s/z)

plot(theta, I_1.(theta, 0) + I_1.(theta,phi), label="I_1 + I_2")

# now we plot the integral from 0 to phi
plot!(theta, I_1_int.(theta,phi), label="Integral from 0 to phi")




