using StatsBase

include("code.jl")

pps = readpps("../data/day4/input")

invkeys = valid.(pairs.(pps))
println(countmap(invkeys))
