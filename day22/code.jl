fn = "./data/example"

function parsestacks(fn)
    lines = readlines(fn)
    playerln = findall(startswith.(lines, "Play"))
    
    ln1, ln2 = playerln

    st1 = parse.(Int, lines[ln1+1:ln2-2])
    st2 = parse.(Int, lines[ln2+1:end])

    st1, st2
end

st1, st2 = parsestacks(fn)

function wins!(sta, stb)
    topa = popfirst!(sta)
    push!(sta, topa)
    push!(sta, popfirst!(stb))
end

function next!(st1, st2)
    if min(length(st1), length(st2)) == 0
        return true
    end
    if first(st1) > first(st2)
        wins!(st1, st2)
    else
        wins!(st2, st1)
    end
    false
end

function play(st1, st2)
    st1 = copy(st1)
    st2 = copy(st2)
    while true
        res = next!(st1, st2)
        if res
            return st1, st2
        end
        println("$(length(st1)) vs $(length(st2))")
    end
    st1, st2
end

function which(sta, stb)
    if length(sta) == 0
        return stb
    elseif length(stb) == 0
        return sta
    end
    throw("Not yet played out!")
end

st1a, st1b = play(st1, st2)
winner = which(st1a, st1b)

function score(stack)
    sum(i * v for (i, v) in enumerate(reverse(stack)))
end

@test score(winner) == 306

# part I

st1, st2 = parsestacks("./data/input")
st1a, st2a = play(st1, st2)
winner = which(st1a, st2a)    
score(winner)

mutable struct gamenb
    n
end

function reccombat!(st1, st2, gamenumber)

    seen = Set{Tuple{Vector{Int64}, Vector{Int64}}}()
    n = copy(gamenumber.n)
    println("# Recursive game $n")

    round = 0
    
    while true  # rounds
        # if seen, done

        if (st1, st2) ∈ seen
            return st1, st2, true
        end

        push!(seen, (copy(st1), copy(st2)))

        # check for win
        if min(length(st1), length(st2)) == 0
            return st1, st2, length(st1) > length(st2)
        end

        # lets go
        dr1, dr2 = popfirst!(st1), popfirst!(st2)
        st1winner = undef

        # determine winner
        if (dr1 <= length(st1)) & (dr2 <= length(st2))
            gamenumber.n += 1
            _, _, st1winner = reccombat!(copy(st1[1:dr1]), copy(st2[1:dr2]), gamenumber)
        else
            st1winner = dr1 > dr2
        end

        if st1winner
            push!(st1, dr1)
            push!(st1, dr2)
        else
            push!(st2, dr2)
            push!(st2, dr1)
        end
   end
end

# part2 test

st1, st2 = parsestacks("./data/example")
st1a, st2a, st1w = reccombat!(copy(st1), copy(st2), gamenb(1))

winner = st1w ? st1a : st2a
@test score(winner) == 291

# part2 

st1, st2 = parsestacks("./data/input")
st1a, st2a, st1w = reccombat!(st1, st2, gamenb(1))

winner = st1w ? st1a : st2a
score(winner)
