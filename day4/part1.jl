include("code.jl")

pps = readpps("../data/day4/input")

valid = issubset.([REQUIRED], elements.(pps))
println(valid)

nvalid = sum(valid)

println("$nvalid docs are valid")
