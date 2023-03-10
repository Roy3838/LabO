

# Script that crops a matrix

function crop(img::Array{Float64,2}, x1::Int, x2::Int, y1::Int, y2::Int)::Array{Float64,2}
    return img[x1:x2, y1:y2]
end
