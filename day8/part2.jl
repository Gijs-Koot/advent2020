#! /usr/bin/env julia

include("code.jl")

instr = readinstr(ARGS[1])

for ix in range(1, stop=length(instr) - 1)

    println("Considering switch at $ix")
    ins = instr[ix]

    if startswith(ins, "jmp")
        newins = "nop"
    elseif startswith(ins, "nop")
        newins = "jmp $(ins[5:end])"
    else
        continue
    end
     
    swap, instr[ix] = (instr[ix], newins)

    pth, acc = processuntilloop(instr)

    if pth[end] == length(instr)
        println("Ran until complete, acc = $acc, pth = $pth")
        println("Changing line $ix fixed it, answer is $acc")
        break
    else
        println("Loop after swapping line $ix")
    end

    instr[ix] = swap

end

     
    

    

    
