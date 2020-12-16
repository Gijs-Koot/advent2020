using Test

seq = [0,3,6]

function next(seq)
    prev = seq[1:end-1]
    last = seq[end]

    if !(last ∈ prev)
        return 0
    end
    
    lment = maximum(findall(prev .== last))

    length(seq) - lment
end

@test next(seq) == 0
@test next([0,3,6,0]) == 3

function build(seq, lenm)
    res = copy(seq)
    while length(res) < lenm
        push!(res, next(res))
    end
    res
end


@test length(build(seq, 100)) == 100
@test build(seq, 2020)[end] == 436
@test build([1, 3, 2], 2020)[end] == 1

ans = build([15,12,0,14,3,1], 2020)[end]

mutable struct Sit
    vals::Set{Int64}
    pos::Dict{Int64, Int64}
    last::Int64
    ix::Int64
end

function update(sit::Sit)
    if !(last ∈ sit.vals)
        next = 0
    else
        next = ix - pos[sit.last]
    end
    # update sit
    push!(sit.vals, sit.last)
    sit.pos[sit.last] = sit.ix
    sit.ix += 1
    sit.last = next
end

function csit(seq::Array{Int64, 1})
    pos = Dict{Int64, Int64}()
    vals = Set{Int64}()
    for (ix, val) in enumerate(seq[1:end-1])
        pos[ix] = val
        push!(vals, val)
    end
    Sit(vals, pos, seq[end], length(seq))
end

sit = csit(seq)
update(sit)
@test update(sit).last == 0

sit = csit([0,3,6])
@test nextd(sit, 5, 0) == 3

function generate(sit, currlen, last, len)
    sit = copy(sit)
    for ix in range(currlen + 1, stop=len)
        last = nextd(sit, ix, last)
        sit[last] = ix
    end
    last
end

generate(sit, 3, 6, 5)


