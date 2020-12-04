include("code.jl")

pps = readpps("../data/day4/example")

nvalid = sum(issubset.([REQUIRED], elements.(pps)))

println("$nvalid docs are valid")
