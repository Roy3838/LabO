using Plots
using LaTeXStrings

gr()
theta = 0:0.05:pi
y = (1/2)*atan.(tan.(2*theta))
plot(theta, y, lc = :blue, lw = 2, grid = :true, 
gridalpha = 0.75, framestyle = :origin, label = "Fase", legendfont = font(10))
    plot!(theta, theta, lc = :red, lw = 2, grid = :true, alpha = 0.5,
gridalpha = 0.3, framestyle = :origin, label = "Fase Desenvuelta", legendfont = font(10),
xguidefontsize = 16, yguidefontsize = 16)
xlabel!(L"\theta")
ylabel!(L"\frac{1}{2}\arctan(\tan(2\theta))")
