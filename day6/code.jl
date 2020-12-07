EXCLUDE = Set(" \n")

groups = open("../data/day6/input") do f
    return strip.(split(read(f, String), "\n\n"))
end


function groupchars(group)
    s = Set(convert(String, group))
    return setdiff(s, EXCLUDE)
end

tot = sum(length.(groupchars.(groups)))

print("total is $tot")


# part II

sets = split.(strip.(groups), "\n")

function consensus(group)
    return reduce(intersect, (Set(p) for p in group))
end

cons = consensus.(sets)

sum(length.(cons))
