#!/usr/bin/env julia

include("code.jl")

instr = readinstr(ARGS[1])

println(instr)

(pth, acc) = processuntilloop(instr)

println(pth)
println(acc)
