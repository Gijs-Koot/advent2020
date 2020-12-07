using LightGraphs

rules = open("../data/day7/input") do f
    return strip.(readlines(f))
end

parsed = match.(r"([\w ]+) bags contain ([\da-z, ]+).", rules)
source = convert.(String, getindex.(parsed, 1))
targetsv = convert.(Array{String}, split.(getindex.(parsed, 2), ", "))

function parsetgt(str)
    m = match(r"(?<amount>\d+) (?<name>\w+ \w+) bags?", str)
    return m
end

nodes = Set{String}()
edges = Set{Tuple{String, String}}()
edgeamount = Dict{Tuple{String, String}, Int}()

for (source, targets) in zip(source, targetsv)
    push!(nodes, source)
    targetsp = parsetgt.(targets)
    for target in targetsp
        if !isnothing(target)
            name = convert(String, target["name"])
            amount = Base.parse(Int, convert(String, target["amount"]))
            edge = Tuple((source, name))

            push!(edges, edge)
            edgeamount[edge] = amount
            push!(nodes, name)
        end
    end
end

function ancestors(g, ix)
    inn = inneighbors(g, ix)
    anc = Set(inn)
    if isempty(anc)
        return anc
    end
    ancc = reduce(union, ancestors(g, an) for an in anc)
    return union(anc, ancc)
end


lookup = Dict(k => v for (v, k) in enumerate(nodes))
revlookup = Dict(v => k for (k, v) in lookup)
edgeamountlookup = Dict(Tuple((lookup[s], lookup[t])) => a for ((s, t), a) in edgeamount)

g = DiGraph()
add_vertices!(g, maximum(values(lookup)))

for (source, target) in edges
    sid = lookup[source]
    tid = lookup[target]
    add_edge!(g, sid, tid)
end

part1 = length(ancestors(g, lookup["shiny gold"]))

println("Answer to part 1 is $part1")

function bagsinside(g, ix)

    sum = 0
    
    for nb in neighbors(g, ix)
        namount = edgeamountlookup[(ix, nb)]
        nbags = bagsinside(g, nb)

        println("$(revlookup[ix]) contains $namount $(revlookup[nb])")

        sum += namount * (nbags + 1)
    end

    println("$(revlookup[ix]) contains $sum bags")
    return sum
end

bagsinside(g, lookup["shiny gold"])
    
