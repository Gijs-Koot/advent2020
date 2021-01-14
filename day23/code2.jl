using Test

mutable struct Cup
    next::Union{Cup, Nothing}
    val::Int64
end

mutable struct Cups
    lookup::Dict{Int64, Cup}
    first::Cup
    lowest::Int64
    highest::Int64
end

function makecircle(vals::Vector{Int})::Cups
    lookup = Dict(i => Cup(nothing, i) for i in vals)
    for (i, _) in enumerate(vals[1:end-1])
        lookup[vals[i]].next = lookup[vals[i+1]]
    end
    lookup[vals[end]].next = lookup[vals[1]]
    Cups(lookup, lookup[vals[1]], minimum(vals), maximum(vals))
end

tst = makecircle([5, 3, 1]) 
@test tst.first.val == 5
@test tst.highest == 5

function Base.display(cups::Cups)
    c = cups.first
    while true
        print(c.val)
        c = c.next
        if c == cups.first
            break
        end
        print("-")
    end
end

cups = makecircle(collect(1:10))

function get(cups::Cups, ix::Int)
    curr = cups.first
    for _ in 1:(ix-1)
        curr = curr.next
    end
    curr
end

@test get(cups, 4).val == 4

function collect_vals(cup::Cup)
    c = cup
    vals = Vector{Int64}()
    while true
        push!(vals, c.val)
        c = c.next
        if (c == cup) | (isnothing(c))
            break
        end
    end
    vals
end

cups = makecircle(collect(1:10))
@test length(collect_vals(cups.first)) == 10

function play!(cups::Cups)
    # The crab picks up the three cups that are immediately clockwise
    # of the current cup. They are removed from the circle; cup
    # spacing is adjusted as necessary to maintain the circle.

    first = cups.first

    pick_start = first.next
    pick_end = get(cups, 4)

    first.next = pick_end.next
    pick_end.next = nothing

    picked_vals = Set(collect_vals(pick_start))
    
    # The crab selects a destination cup: the cup with a label equal
    # to the current cup's label minus one. If this would select one
    # of the cups that was just picked up, the crab will keep
    # subtracting one until it finds a cup that wasn't just picked
    # up. If at any point in this process the value goes below the
    # lowest value on any cup's label, it wraps around to the highest
    # value on any cup's label instead.

    look_for = first.val - 1
    if look_for < cups.lowest
        look_for = cups.highest
    end

    while look_for ∈ picked_vals
        look_for -= 1
        if look_for < cups.lowest
            look_for = cups.highest
        end
    end

    dest = cups.lookup[look_for]

    # The crab places the cups it just picked up so that they are
    # immediately clockwise of the destination cup. They keep the same
    # order as when they were picked up.

    swap = dest.next
    dest.next = pick_start
    pick_end.next = swap  
    
    # The crab selects a new current cup: the cup which is immediately
    # clockwise of the current cup.

    cups.first = first.next
    cups
end

cups = makecircle(collect(1:10))

cups = makecircle(parse.(Int, split("389125467", "")))

function play!(cups::Cups, n::Int64)
    for _ in 1:n
        play!(cups)
    end
    cups
end

# part I

cups = makecircle(parse.(Int, split("389125467", "")))
res = play!(cups, 10);
ans = join(collect_vals(res.lookup[1])[2:end])

@test ans == "92658374"

cups = makecircle(parse.(Int, split("389125467", "")))
res = play!(cups, 100);
ans = join(collect_vals(res.lookup[1])[2:end])

@test ans == "67384529"

# part II

# test

start = parse.(Int, split("389125467", ""))
cups = makecircle(vcat(start, 10:1_000_000));
res = play!(cups, 10_000_000);

cup1 = res.lookup[1];
@test cup1.next.val * cup1.next.next.val == 149245887792

# real

start = parse.(Int, split("963275481", ""))
cups = makecircle(vcat(start, 10:1_000_000));
res = play!(cups, 10_000_000);

cup1 = res.lookup[1];
cup1.next.val * cup1.next.next.val
