function readinstr(fn)
    open(fn) do f
        readlines(f)
    end
end

function processuntilloop(instr)

    acc = 0
    path = Array{Int, 1}()
    current = 1
    len = length(instr)

    while !(current ∈ path) & (current <= len)
        push!(path, current)
        ins = instr[current]
        
        if startswith(ins, "acc")
            acc += parse(Int, ins[5:end])
            current += 1
        elseif startswith(ins, "nop")
            current += 1
        elseif startswith(ins, "jmp")
            current += parse(Int, ins[5:end])
        else
            throw("Invalid instruction $ins")
        end
    end
    
    Tuple((path, acc))
end

    
            
        
                             
                         
            
            
    
    
