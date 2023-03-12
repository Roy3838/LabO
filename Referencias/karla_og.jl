# using LinearAlgebra
using Plots, LaTeXStrings
using Images
using DSP

tamano = (1024,1280,4);         # Tamaño del proyector
p = 16;                         # Periodo (20 o 16)

## Huevo y Boltita es p = 20, otros es p = 16 ##

# Matrices vacías
Samples = zeros(tamano);
Isample = zeros(tamano);
isample = zeros(tamano);

x1 = collect(0:2pi/p:2pi-2pi/p);

# Intensidades de referencia para proyectar
isample[:,:,1] = (repeat((cos.(x1'./2)).^2,tamano[1],Int64.(tamano[2]/p)));
isample[:,:,2] = (repeat((cos.(x1'./2 .+ pi/4)).^2,tamano[1],Int64.(tamano[2]/p)));
isample[:,:,3] = (repeat((cos.(x1'./2 .+ pi/2)).^2,tamano[1],Int64.(tamano[2]/p)));
isample[:,:,4] = (repeat((cos.(x1'./2 .+ 3pi/4)).^2,tamano[1],Int64.(tamano[2]/p)));

# Referencia medida
Isample[:,:,1] = convert.(N0f8,(Gray.(imresize(load("C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Karla/Franjas 1.JPG"),tamano[1:2]))));
Isample[:,:,2] = convert.(N0f8,(Gray.(imresize(load("C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Karla/Franjas 2.JPG"),tamano[1:2]))));
Isample[:,:,3] = convert.(N0f8,(Gray.(imresize(load("C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Karla/Franjas 3.JPG"),tamano[1:2]))));
Isample[:,:,4] = convert.(N0f8,(Gray.(imresize(load("C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Karla/Franjas 4.JPG"),tamano[1:2]))));

# Intensidades medidas del objeto
Samples[:,:,1] = convert.(N0f8,(Gray.(imresize(load("C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Karla/Referencia 1.JPG"),tamano[1:2]))));
Samples[:,:,2] = convert.(N0f8,(Gray.(imresize(load("C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Karla/Referencia 2.JPG"),tamano[1:2]))));
Samples[:,:,3] = convert.(N0f8,(Gray.(imresize(load("C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Karla/Referencia 3.JPG"),tamano[1:2]))));
Samples[:,:,4] = convert.(N0f8,(Gray.(imresize(load("C:/Documentos/Studying/Clases/6to Semestre/LabOptica/LabO/pikas/Karla/Referencia 4.JPG"),tamano[1:2]))));

dataS = float.(Samples);
dataI = float.(Isample);
minimum(dataI[:,:,2])
# Fase de intensidad de referencia
Φi = atan.(-(dataI[:,:,2] -dataI[:,:,4]),(dataI[:,:,1]-dataI[:,:,3]));

# Fase de intensidad de objeto medido
Φs = atan.(-(dataS[:,:,2] - dataS[:,:,4]),(dataS[:,:,1]-dataS[:,:,3]));

# Fase de intensidad de objeto medido desenvuekta
Φu = unwrap(Φs-Φi,dims = 1:2,range = 2pi);
heatmap(Φu)
θ = deg2rad(12.46);             # Angulo entre la cámara y el proyector
α = deg2rad(8)               # Angulo entre la altura de los dos

if p ==  20 
    p1 = 0.016;             # Medición de Maximo a Maximo  para un periodo de 20 pixeles
else
    p1 = 0.016*16/20;
end

# Reescalamos los vectores de pixeles para hacer medición en metros
xx = p1/p*collect(0:1280-1);
yy = p1/p*collect(0:1024-1);

# Función de reconstrucción
Zz = ((Φu)/2pi).*(p1/(tan(θ)+tan(α)));

plotlyjs()
h1 = plot(xx,yy,abs.(Zz),st = :surface,zlim = (0,0.4),xlim = (0,1),ylim = (0,1),c= :dense,camera = (50, 40))


