using Test
using StatsBase

NS = Set(['n', 's'])


function splitroute(routestr)
    # splits route into codes
    # e, se, sw, w, nw, and ne
    i = 1
    len = length(routestr)
    res = Vector{String}()
    while i <= len
        if routestr[i] ∈ NS
            push!(res, routestr[i:i+1])
            i += 2
        else
            push!(res, routestr[i:i])
            i += 1
        end
    end
    res
end

            
@test length(splitroute("nene")) == 2
@test splitroute("neswnwewnwnwseenwseesewsenwsweewe")[end] == "e"

COORDS = Dict("e" => [-2, 0], "ne" => [-1, 1], "se" => [-1, -1],
              "w" => [2, 0], "nw" => [1, 1], "sw" => [1, -1])

route = splitroute("neswnwewnwnwseenwseesewsenwsweewe")

function coordinate(route)
    crd = hcat([COORDS[step] for step in route]...)
    vec(sum(crd, dims=2))
end

coordinate(route)

counts = countmap(coordinate.(splitroute.(readlines("./data/example"))))

@test countmap(values(counts))[2] == 5

# part I

counts = countmap(coordinate.(splitroute.(readlines("./data/input"))))
x = sum(.!iseven.(values(counts)))

# part II

counts = countmap(coordinate.(splitroute.(readlines("./data/example"))))
black = Set(k for (k, v) in counts if !iseven(v))
DIRECTIONS = values(COORDS)

function nblacknb(c, black)
    sum((c + d) ∈ black for d in DIRECTIONS)
end

function flip(black)

    res = Set{Array{Int64, 1}}()
    scope = reduce(union, [[b + d for b in black] for d in DIRECTIONS])
    white = setdiff(scope, black)

    for b in black
        nb = nblacknb(b, black)
        if nb ∈ [1, 2]
            push!(res, b)
        end
    end

    for w in white
        if nblacknb(w, black) == 2
            push!(res, w)
        end
    end
    
    res
end

function flip(black, n)
    curr = black
    for _ in 1:n
        curr = flip(curr)
    end
    curr
end

@test length(flip(black, 100)) == 2208

# real

counts = countmap(coordinate.(splitroute.(readlines("./data/input"))))
black = Set(k for (k, v) in counts if !iseven(v))

length(flip(black, 100))
