lines = filter(x -> length(x) > 0, open(readlines, "./data/input"))
mat = hcat([[l[ix] for ix in range(1, length=length(l))] for l in lines]...)
mat = permutedims(mat)

# for part I
function vals(mat::Array{Char, 2}, r, c)
    res = Array{Char, 1}()
    h, w = size(mat)
    
    for ir in range(max(1, r-1), stop=min(r+1, h))
        for ic in range(max(1, c-1), stop=min(c+1, w))
            if (ir == r) & (ic == c)
                continue
            end
            push!(res, mat[ir, ic])
        end
    end
    res
end
               
function hasoccupiednb(mat, r, c)
    '#' ∈ vals(mat, r, c)
end

function fouroccupiednb(mat, r, c)
    sum(vals(mat, r, c) .== '#') > 3
end

function fiveoccupiednb(mat, r, c)
    sum(vals(mat, r, c) .== '#') > 4
end

function next(mat::Array{Char, 2})
    res = copy(mat)
    height, width = size(mat)

    for ic in range(1, length=width)
        for ir in range(1, length=height)
            val = mat[ir, ic]
            if (val == 'L') & !(hasoccupiednb(mat, ir, ic))
                res[ir, ic] = '#'
            elseif (val == '#') & (fiveoccupiednb(mat, ir, ic))
                res[ir, ic] = 'L'
            else
                res[ir, ic] = mat[ir, ic]
            end
        end
    end
    res
end

function findfixed(mat)
    prev = mat
    for i in range(1, stop=1000)
        new = next(prev)
        if new == prev
            return new
        end
        prev = new
    end
end

sum(findfixed(mat) .== '#')
        
# part II; replace vals func

directions = [1 1; 1 0; 1 -1; 0 1; 0 -1; -1 1; -1 0; -1 -1]

function checkdir(mat, dir, r, c)
    h, w = size(mat)
    dr, dc = dir
    while (0 < (r += dr) <= h) & (0 < (c += dc) <= w)
        if mat[r, c] != '.'
            return mat[r, c]
        end
    end
end

function vals(mat::Array{Char, 2}, r, c)
    ret = Array{Char, 1}()
    for direction in eachrow(directions)
        val = checkdir(mat, direction, r, c)
        if !isnothing(val)
            push!(ret, val)
        end
    end
    ret
end


    
