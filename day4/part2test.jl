include("code.jl")

invalid_pps = pairs.(readpps("../data/day4/invalid"))
valid_pps = pairs.(readpps("../data/day4/valid"))

for pp in invalid_pps
    println(pp)
    println(valid(pp))
end

for pp in valid_pps
    println(pp)
    println(valid(pp))
end

lines = open("../data/day4/validtest") do f
    return split.(readlines(f), ":")
end
