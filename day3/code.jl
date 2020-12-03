lines = open("../data/day3/input") do io
    return map(strip, readlines(io))
end

function trees_found(lines, hstep, vstep)
    width = length(lines[1])
    sum = 0

    for (i, row) in enumerate(range(1, stop=length(lines), step=hstep))
        col = mod((i - 1) * vstep, width) + 1
        sum += lines[row][col] == '#'
    end

    return sum
end

ntrees = trees_found(lines, 1, 3)

println("$ntrees trees encountered")

# part II



slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]

prod = 1

for (vstep, hstep) in slopes
    global prod
    ans = trees_found(lines, hstep, vstep)
    println("$vstep $hstep $ans")
    prod *= ans
end


println("the product equals $prod")
