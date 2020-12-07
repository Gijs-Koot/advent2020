include("code.jl")

ids = open("../data/day5/input") do f
    return seatid.(readlines(f))
end

println(ids[1:5])
println("Max id is $(maximum(ids))")
