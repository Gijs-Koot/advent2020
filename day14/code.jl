using Test

lines = open(readlines, "./data/example")

function parsemaskline(line)
    strip(split(line, "=")[2])
end

function apply(mask, num::Int64)
    bin = bitstring(num)[end-35:end]
    res = Array{Bool, 1}()
    
    for (m, b) in zip(mask, bin)
        if m == '0'
            push!(res, false)
        elseif m == '1'
            push!(res, true)
        else
            push!(res, b == '1')
        end
    end
    println(res)
    sum(2::Int64 .^ range(35, step=-1, length=36) .* res)
end

mask = parsemaskline(lines[1])

@test apply(mask, 11) == 73
@test apply(mask, 101) == 101
@test apply(mask, 0) == 64

function parsememline(line)
    m = match(r"mem\[(\d+)\] = (\d+)", line)
    parse(Int64, m[1]), parse(Int64, m[2])
end

@test parsememline.(lines[2:end]) == [(8, 11), (7, 101), (8, 0)]

function eval(lines)

    mask = parsemaskline(lines[1])
    mem = Dict{Int64, Int64}()
    
    for line in lines[2:end]
        if startswith(line, "mask")
            mask = parsemaskline(line)
        else
            pos, val = parsememline(line)
            mem[pos] = apply(mask, val)
        end
    end

    mem
end

@test sum(values(eval(lines))) == 165
            
input_lines = open(readlines, "./data/input")
mem = eval(input_lines)

ans = sum(values(mem))
ans

# part II

function apply2(mask, num)
    # returns an floatthingy
    bin = bitstring(num)[end-35:end]
    res = Array{Char, 1}()
    
    for (m, b) in zip(mask, bin)
        if m == '0'
            push!(res, b)
        elseif m == '1'
            push!(res, '1')
        else
            push!(res, 'X')
        end
    end
    res
end

mask = "000000000000000000000000000000X1001X"
ft = [c for c in "0X01"]

@test apply2(mask, 42) == [c for c in "000000000000000000000000000000X1101X"]

function replacefirstx(floatthing::Array{Char, 1}, replace::Char)
    ft = copy(floatthing)
    for (i, c) in enumerate(ft)
        if c == 'X'
            ft[i] = replace
            return ft
        end
    end
    ft
end

@test replacefirstx(ft, '1') == [c for c in "0101"]

function addresses(floatthing::Array{Char})
    res = Set{Int64}()
    if !('X' ∈ floatthing)
        s = sum(2::Int64 .^ range(35, step=-1, length=36) .* (floatthing .== '1'))
        push!(res, s)
        return res
    else
        for replace in ['0', '1']
            rep = replacefirstx(floatthing, replace)
            res = union(res, addresses(rep))
        end
    end
    res
end

simple = [c for c in "000000000000000000000000000000011010"]

@test addresses(simple) == Set([26])

mask = "000000000000000000000000000000X1101X"
@test addresses([c for c in mask]) == Set([26, 27, 58, 59])


mask = "00000000000000000000000000000001X0XX"
@test addresses([c for c in mask]) == Set([16, 17, 18, 19, 24, 25, 26, 27])

function eval2(lines)
    mask = parsemaskline(lines[1])
    mem = Dict{Int64, Int64}()
    for (ix, line) in enumerate(lines[2:end])
        if startswith(line, "mask")
            mask = parsemaskline(line)
        else
            pos, val = parsememline(line)
            ft = apply2(mask, pos)
            for addr in addresses(ft)
                mem[addr] = val
            end
        end
    end
    mem
end

mem = eval2(input_lines)
ans = sum(values(mem))

ans
