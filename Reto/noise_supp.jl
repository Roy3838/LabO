# ------------NOISE SUPPRESSION----------#

function noise_supp(img::Array{Float64,2}, sze::Int)::Array{Float64,2}

    noissupp = 1/((2*sze+1)^2) * ones(2*sze+1,2*sze+1)
    h = length(img[:,1])
    w = length(img[1,:])
    nois_mat = zeros(h,w)

    for ii in range(sze+1, h-sze-1)
        for jj in range(sze+1, w-sze-1)
            nois_mat[ii, jj] = sum(noissupp.*img[ii-sze:ii+sze, jj-sze:jj+sze])
        end
    end

    return nois_mat

end