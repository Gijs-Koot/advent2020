

lines = readlines("./data/example")

function parserules(lines)    
    rules = filter(x -> !isnothing(match(r"^\d+:", x)), lines)
    rules = split.(rules, ":")
    
    nums = [parse(Int, r[1]) for r in rules]
    rule = [strip(r[2]) for r in rules]

    Dict(zip(nums, rule))
end

rules = parserules(lines)

CHAR = r"\"(\w)\""

function sat(rules, ix)::Set{String}
    rule = rules[ix]

    m = match(CHAR, rule)
    if !isnothing(m)
        return Set([rule[2:2]])
    end
    
    orgroups = split(rule, "|")
    orm = Vector{Set{String}}()

    for group in orgroups
        ixs = parse.(Int, split(strip(group), " "))
        matches = [sat(rules, ix) for ix in ixs]
        combos = [p for p in product(matches...)]
        strings = reduce.(*, combos)
        push!(orm, Set(strings))
    end

    reduce(union, orm)
end

sat(rules, 5)
sat(rules, 0)

# part I

lines = readlines("./data/input")
rules = parserules(lines)

matches = sat(rules, 0)

words = filter(x -> startswith(x, r"[ab]"), lines)

ans = length(intersect(words, matches))
