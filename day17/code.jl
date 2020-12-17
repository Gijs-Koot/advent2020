using DataStructures
using IterTools
using Test

function readtomat(fn)
    m  = reduce(hcat, [split(l, "") for l in readlines(fn)])
    Set([[v[1], v[2], 0] for v in findall(m .== "#")])
end

pts = readtomat("./data/example")

@test length(pts) == 5
DIRECTIONS = setdiff(Set(product(-1:1, -1:1, -1:1)), Set([Tuple([0, 0, 0])]))
DIRECTIONS = collect.(DIRECTIONS)

@test length(DIRECTIONS) == 26

function neighbors(pt::Vector{Int64})
    res = Vector{Vector{Int64}}()
    for dv in DIRECTIONS
        new = pt + dv
        push!(res, new)
    end
    res
end

@test length(neighbors(first(pts))) == 26

function nbcount(pts)
    dd = DefaultDict{Vector{Int64}, Int64}(0)
    for pt in pts
        for nb in neighbors(pt)
            dd[nb] += 1
        end
    end
    dd
end

nbc = nbcount(pts)

function next(pts)
    nbc = nbcount(pts)

    three_nb = [k for (k, v) in nbc if v == 3]
    two_nb = [k for (k, v) in nbc if v == 2]

    union(intersect(pts, two_nb), three_nb)
end

# I count 11 tags after first phase
@test length(next(pts)) == 11

function cycles(pts, n)
    res = pts
    for i in 1:n
        res = next(res)
    end
    res
end

@test length(cycles(pts, 6)) == 112

# part I

pts = readtomat("./data/input")
length(cycles(pts, 6))

# part II

DIRECTIONS = setdiff(Set(product(-1:1, -1:1, -1:1, -1:1)), Set([Tuple([0, 0, 0, 0])]))
DIRECTIONS = collect.(DIRECTIONS)
@test length(DIRECTIONS) == 80

pts4d = [vcat(pt, 0) for pt in pts]

length(cycles(pts4d, 6))
