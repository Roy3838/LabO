# ------------NOISE SUPPRESSION----------#
using ImageFiltering
function noise_supp(img::Array{Float64,2}, sze::Int)::Array{Float64,2}

    kern1 = 1/(2*sze+1) * ones(1,2*sze+1)
    kernf = kernelfactors((kern1, kern1))
    img = imfilter(img, kernf)

    return img

end