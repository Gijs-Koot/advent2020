nums = parse.(Int, filter(x -> length(x) > 0, open(readlines, "./data/input")))
nums = vcat([0], nums, [maximum(nums) + 3])

diffs = diff(sort(nums))

sum(diffs .== 1) * sum(diffs .== 3)



# number of arrangements is the the number of arrangements of each "1-group"

1 1 1

3
2 1
1 2

1 1 1 1

2 2
3 1
1 3
1 1 2
2 1 1
1 2 1

1 1 1 1 1

2 3
3 2

1 1 3
3 1 1
1 3 1

2 2 1
2 1 2
1 2 2

using DataStructures


function push(n::Int, dct::DefaultDict{Int, Int})
    # creates a new copy when needed
    nw = copy(dct)
    nw[n] += 1
    nw
end

function ncomb(dct::DefaultDict{Int, Int})
    factorial(sum(values(dct))) ÷ prod(factorial.(values(dct)))
end

function ncomb(l::Int)
    # number of combinations in a onegroup of length l
    sum(ncomb.(subgroups(l)))
end


function subgroups(l)
    # subgroups for length l

    if l == 0
        return Set([DefaultDict{Int, Int}(0)])
    end
    
    if l == 1
        def = DefaultDict{Int, Int}(0)
        def[1] += 1
        return Set([def])
    end

    res = Set{DefaultDict{Int, Int}}()
    
    for start in range(1, length=min(l, 3))
        for group in subgroups(l - start)
            push!(res, push(start, group))
        end
    end

    res
end

subgroups(2)
    

function onegroups(arr)

    res = Array{Int, 1}()
    curr = 0
    
    for (ix, el) in enumerate(arr)
        if el == 1
            curr += 1
        elseif curr > 0
            append!(res, curr)
            curr = 0
        end
    end

    res
end

prod(ncomb.(onegroups(diffs)))
