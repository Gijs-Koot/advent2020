using Memoize
using Test
using IterTools

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

# part II

# 0: 8 11
# 8: 42 | 42 8
# 11: 42 31 | 42 11 31

sat42 = sat(rules, 42)
len42 = length(first(sat42))
sat8 = sat(rules, 8)
len8 = length(first(sat8))

sat11 = sat(rules, 11)
len11 = length(first(sat11))
sat31 = sat(rules, 31)
len31 = length(first(sat31))

# WTF sat42 == sat8
# 0: 42* 31** (8)
# where * => **
# * >= 2, ** >= 1

# allright so its first at least 2 combinations of 42, then a combination of 31

function split4231(w)

    ix = 1
    n42 = 0
    n31 = 0
    
    while ix < length(w)
        sub = w[ix:ix+7]
        if !(sub ∈ sat42) break end
        n42 += 1
        ix += 8
    end

    while ix < length(w)
        sub = w[ix:ix+7]
        if !(sub ∈ sat31) break end
        n31 += 1
        ix += 8
    end

    return n42, n31, (length(w) - ix + 1)
end

@test split4231(first(sat42)) == (1, 0, 0)

splits = split4231.(words)
works = [(a >= 2, b >= 1, c == 0, a >= b + 1) for (a, b, c) in splits]
satzero = map(x -> reduce(&, x), works)
ans = sum(satzero)
