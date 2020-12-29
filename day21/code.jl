using Test
using IterTools

lreg = r"([a-z ]+) \(contains ([\w, ]+)\)"

function parseings(fn)
    res = Vector{Tuple{Vector{String}, Vector{String}}}()
    lines = readlines(fn)
    for m in match.(lreg, lines)
        ing = split(m[1], " ")
        all = split(m[2], ", ")
        push!(res, (ing, all))
    end
    res
end

fn = "./data/example"

menu = parseings(fn)

function possibilities(menu)
    
    allergens = reduce(union, [r[2] for r in menu])
    ingredients = reduce(union, [r[1] for r in menu])
    
    dd = Dict{String, Set{String}}()
    
    for allergen in allergens
        dd[allergen] = Set(ingredients)
    end
    
    for rec in menu
        ings, alls = rec
        for allergen in alls
            dd[allergen] = intersect(dd[allergen], Set(ings))
        end
    end

    dd
end

dd = possibilities(menu)
safe = setdiff(ingredients, union(values(dd)...))
mentions = vcat([r[1] for r in menu]...)
ans = sum(map(x -> x ∈ safe, ingredient_mentions))

@test ans == 5

# part I

menu = parseings("./data/input")
dd = possibilities(menu)
ingredients = union([r[1] for r in menu]...)
safe = setdiff(ingredients, union(values(dd)...))
mentions = vcat([r[1] for r in menu]...)
ans = sum(map(x -> x ∈ safe, mentions))

# part II

choices = copy(dd)
assignments = Dict{String, String}()

for _ in dd
    for (k, v) in choices
        if length(v) == 1
            println("eliminating $v")

            assignments[k] = first(v)
            
            # remove from choices

            for k in keys(choices)
                choices[k] = setdiff(choices[k], Set([first(v)]))
            end
            
            break
        end
    end
end

ans = join(map(x -> x.second, sort(collect(assignments))), ",")
