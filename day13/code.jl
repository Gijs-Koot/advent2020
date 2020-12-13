lines = open(readlines, "./data/input")

tm = parse(Int, lines[1])

schedf = filter(x -> x != "x", split(lines[2], ","))
schedp = parse.(Int, schedf)

function closest(tgt, sch)
    r = 0
    while r * sch < tgt
        r += 1
    end
    r * sch
end

waitt = closest.(tm, schedp)
schedp[argmin(waitt)] * (minimum(waitt) - tm)

# part II

using Test

function parseconstr(s)
    [(parse(Int, q) - i + 1, parse(Int, q)) for (i, q) in enumerate(split(s, ",")) if !(q == "x")]
end

# following https://www.youtube.com/watch?v=zIFehsBHB8o

function ni(constr)
    N = prod(x -> x[2], constr)
    [convert(Int, N / con[2]) for con in constr]
end

function bi(constr)
    map(x -> x[1], constr)
end

constr = [(3, 5), (1, 7), (6, 8)]

@test ni(constr) == [56, 40, 35]
@test bi(constr) == [3, 1, 6]

function inv(n, m)
    nmod = n % m
    curr = 1
    while !(curr * nmod % m == 1)
        curr += 1
    end
    curr
end

@test inv(56, 5) == 1
@test inv(40, 7) == 3
@test inv(35, 8) == 3

function xi(constr)
    [inv(n, constr[2]) for (n, constr) in zip(ni(constr), constr)]
end

@test xi(constr) == [1, 3, 3]

function solverem(constr)
    s = sum(ni(constr) .* bi(constr) .* xi(constr))
    s % prod(getindex.(constr, 2))
end

@test solverem(constr) == 78

constr = parseconstr(lines[2])

constr = parseconstr("7,13,x,x,59,x,31,19")
@test solverem(constr) == 1068781

constr = parseconstr("17,x,13,19")
@test solverem(constr) == 3417

constr = parseconstr("1789,37,47,1889")
@test solverem(constr) == 1202161486

lines = open(readlines, "./data/input")
constr = parseconstr(lines[2])
solverem(constr)
