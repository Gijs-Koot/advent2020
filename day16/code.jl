# part I
lines = open(readlines, "./data/input")

ticketln = findall(lines .== "your ticket:")[1]
nearbyln = findall(lines .== "nearby tickets:")[1]

ytick = parse.(Int64, split(lines[ticketln + 1], ","))
nticks = permutedims(parse.(Int64, hcat(split.(lines[nearbyln + 1:end], ",")...)))

nticks[1,:]

rules = reduce(hcat, split.(lines[1:ticketln-2], ":"))

rulerng = map(x -> split.(x, "-"), split.(rules[2, :], " or "))

rulerngp = Array{Array{Int64, 1}, 1}()

for rule in rulerng
    ranges = map.(x -> parse(Int64, x), rule)
    val = reduce(union, range(s, stop=e) for (s, e) in ranges)
    push!(rulerngp, val)
end

# allright ruleparsing done
validall = reduce(union, rulerngp)
valid = [issubset(ntick, validall) for ntick in nticks]
sum(nticks .* (1 .- valid)) # ans to part I

# part II

# remove invalid tickets - ehm idk about fancy indexing yet
validix = findall([all(row) for row in eachrow(valid)])
vticks = permutedims(reduce(hcat, [nticks[i, 1:end] for i in validix]))

# matrix for columns that fit rules
# probably some oneliner for this but ok
validcol = zeros(Bool, (20, 20))
for (ir, rng) in enumerate(rulerngp)
    for (ic, col) in enumerate(eachcol(vticks))
        validcol[ir, ic] = issubset(col, rng)
    end
end

rulecol = Dict{Int64, Int64}()

# elimination
# this relies on the fact that there is only one solution
# and also the validcols are perfectly aligned - thanks for that, adventmaster
for ir in sortperm(map(sum, eachrow(validcol)))
    fits = findall(validcol[ir, 1:end])
    open = setdiff(fits, values(rulecol))
    rulecol[ir] = open[1]
    println(open)
end

# got this wrong a couple of times :) must learn to read! 
deprules = findall(startswith.(rules[1, :], "depa"))
depcols = [rulecol[ir] for ir in deprules]
prod(ytick[depcols]) # ans to part two
