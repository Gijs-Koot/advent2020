using Test

function dest(curr, rest, picked)
    destix = 0
    for look in (curr-1):-1:1
        if look ∈ picked
            continue
        end
        for (ix, val) in enumerate(rest)
            if val == look
                destix = ix
                break
            end
        end
        break
    end

    if destix == 0
        destix = argmax(rest)
    end
    destix
end

dest(curr, rest, picked)

function next(cups::Vector{Int})

    n = length(cups)
    curr = cups[1]
    rest = cups[5:end]
    picked = cups[2:4]

    # select dest
    destix = dest(curr, rest, picked)

    # assemble
    intr = [rest[destix] ; picked ; rest[destix+1:end] ; curr ; rest[1:destix-1]]

    # find back old index
    ix = n - destix + 2

    # select next in front
    [intr[ix:end] ; intr[1:ix-1]]
end

function play(cups, n)
    res = cups
    for i in 1:n
        res = next(res)
        if (i % 1000) == 0
            println("$i games played")
        end
    end
    res
end


function answer(cups)
    ix = argmax(cups .== 1) + 1 % length(cups)
    join([cups[ix:end]; cups[1:ix-2]])
end

cups = parse.(Int, split("389125467", ""))

@test answer(play(cups, 10)) == "92658374"
@test answer(play(cups, 100)) == "67384529"

@time play(cups, 100)

# part I

cups = parse.(Int, split("963275481", ""))
answer(play(cups, 100))

# part II

start = parse.(Int, split("389125467", ""))
mill = 10 ^ 6
cups = [start; 10:mill]

@time play(cups, 1);
