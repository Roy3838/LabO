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

# Objeto medida
Isample[:,:,1] = convert.(N0f8,(Gray.(imresize(load("C:/Users/JayPC/LabO/pikas/Fotos_jueves_9/DSC_0002_finas _0.JPG"),tamano[1:2]))));
Isample[:,:,2] = convert.(N0f8,(Gray.(imresize(load("C:/Users/JayPC/LabO/pikas/Fotos_jueves_9/DSC_0003_finas_45.JPG"),tamano[1:2]))));
Isample[:,:,3] = convert.(N0f8,(Gray.(imresize(load("C:/Users/JayPC/LabO/pikas/Fotos_jueves_9/DSC_0004_finas_90.JPG"),tamano[1:2]))));
Isample[:,:,4] = convert.(N0f8,(Gray.(imresize(load("C:/Users/JayPC/LabO/pikas/Fotos_jueves_9/DSC_0005_finas_135.JPG"),tamano[1:2]))));


Iref = zeros(350,300,4)
Isam = zeros(350,300,4)

# Referencia medida
Irefimport = convert.(N0f8,(Gray.(imresize(load("C:/Users/JayPC/LabO/pikas/Fotos_jueves_9/DSC_0006_finas_ref.JPG"),tamano[1:2]))));



#Crop
Isam[:,:,1] = Isample[301:650,501:800, 1]
Isam[:,:,2] = Isample[301:650,501:800, 2]
Isam[:,:,3] = Isample[301:650,501:800, 3]
Isam[:,:,4] = Isample[301:650,501:800, 4]
Iref[:,:,1] = Irefimport[301:650,501:800]

#Cuchareada
function cuchareada(Matrix)
    cropsito = Matrix[1:50,:]
    # mirror in vertical axis
    cropsitomirror = cropsito[end:-1:1,:]
    # concatenate cropsitos
    cropsitot = vcat(cropsito, cropsitomirror)
    cropsitot = vcat(cropsitot, cropsito)
    cropsitot = vcat(cropsitot, cropsitomirror)
    cropsitot = vcat(cropsitot, cropsito)
    cropsitot = vcat(cropsitot, cropsitomirror)
    cropsitot = vcat(cropsitot, cropsito)

    return cropsitot
end

Iref[:,:,2] = cuchareada(Isam[:,:,2])
Iref[:,:,3] = cuchareada(Isam[:,:,3])
Iref[:,:,4] = cuchareada(Isam[:,:,4])

heatmap(Isam[:,:,2])









# Isample[:,:,2] = convert.(N0f8,(Gray.(imresize(load("6_LabOptica/NuevosSamplesReto/Samples_29Abril/Huevo Chido/Referencia 2.JPG"),tamano[1:2]))));
# Isample[:,:,3] = convert.(N0f8,(Gray.(imresize(load("6_LabOptica/NuevosSamplesReto/Samples_29Abril/Huevo Chido/Referencia 3.JPG"),tamano[1:2]))));
# Isample[:,:,4] = convert.(N0f8,(Gray.(imresize(load("6_LabOptica/NuevosSamplesReto/Samples_29Abril/Huevo Chido/Referencia 4.JPG"),tamano[1:2]))));

# # Intensidades medidas del objeto
# Samples[:,:,1] = convert.(N0f8,(Gray.(imresize(load("6_LabOptica/NuevosSamplesReto/Samples_29Abril/Huevo Chido/Franjas 1.JPG"),tamano[1:2]))));
# Samples[:,:,2] = convert.(N0f8,(Gray.(imresize(load("6_LabOptica/NuevosSamplesReto/Samples_29Abril/Huevo Chido/Franjas 2.JPG"),tamano[1:2]))));
# Samples[:,:,3] = convert.(N0f8,(Gray.(imresize(load("6_LabOptica/NuevosSamplesReto/Samples_29Abril/Huevo Chido/Franjas 3.JPG"),tamano[1:2]))));
# Samples[:,:,4] = convert.(N0f8,(Gray.(imresize(load("6_LabOptica/NuevosSamplesReto/Samples_29Abril/Huevo Chido/Franjas 4.JPG"),tamano[1:2]))));





dataS = float.(Iref);
dataI = float.(Isam);

# Fase de intensidad de referencia
Φi = atan.(-(dataI[:,:,2] -dataI[:,:,4]),(dataI[:,:,1]-dataI[:,:,3]));

# Fase de intensidad de objeto medido
Φs = atan.(-(dataS[:,:,2] - dataS[:,:,4]),(dataS[:,:,1]-dataS[:,:,3]));

# Fase de intensidad de objeto medido desenvuekta
Φu = unwrap(Φs-Φi,dims = 1:2,range = 2pi);

θ = atan(18/50);             # Angulo entre la cámara y el proyector
α = deg2rad(0)               # Angulo entre la altura de los dos

if p ==  20 
    p1 = 0.016;             # Medición de Maximo a Maximo  para un periodo de 20 pixeles
else
    p1 = 0.016*16/20;
end

# Reescalamos los vectores de pixeles para hacer medición en metros
xx = p1/p*collect(0:1280-1);
yy = p1/p*collect(0:1024-1);

# Función de reconstrucción
Zz = ((Φu)/2pi).*(p1/(tan(θ)+tan(α))); # p2 en la matrix

plotlyjs()
h1 = plot(xx,yy,abs.(Zz),st = :surface,zlim = (0,0.4),xlim = (0,1),ylim = (0,1),c= :dense,camera = (50, 40))