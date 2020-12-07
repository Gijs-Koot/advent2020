function missing(st)
    vals = range(minimum(st), stop=maximum(st))
    ixs = Set(vals)
    return setdiff(ixs, st)
end
    

function holes(st)
    ret = Set()
    for val in missing(st)
        if issubset(Set([val + 1, val - 1]), st)
            push!(ret, val)
        end
    end
    return ret
end


function seqbinsum(str, eqstr)
    l = length(str)
    return sum(eq * 2 ^ (l - i) for (i, eq) in enumerate(split(str, "") .== eqstr))
end

function seatid(str)
    partstr = str[1:7]
    colstr = str[8:10]

    return 8 * seqbinsum(partstr, "B") + seqbinsum(colstr, "R")
end

