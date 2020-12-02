struct Rule
    char::Char
    nmin::Int
    nmax::Int
end

function Base.parse(::Type{Rule}, str)
    # parses 8-9 x into a rule
    m = match(r"(\d+)-(\d+) (\w)", str)
    return Rule(str[m[3].offset + 1], parse(Int, m[1]), parse(Int, m[2]))
end

function Base.count(c::Char, str::String)
    return count(x -> x == c, str)
end

## for part I
function matches(rule::Rule, str::String)
    s = count(rule.char, str)
    return (s >= rule.nmin) & (s <= rule.nmax)
end

## for part II
function matches_p2(rule::Rule, str)
    return (str[rule.nmin] == rule.char) ⊻ (str[rule.nmax] == rule.char)
end

lines = open("../data/day2/input") do io
    return split(strip(read(io, String)), "\n")
end

lst = Vector{Tuple{Rule, String}}()

for line in lines

    println(line)
    
    rraw, rpwd = map(strip, split(line, ":"))

    rule = parse(Rule, convert(String, rraw))
    pwd = convert(String, rpwd)

    push!(lst, (rule, pwd))

    if matches_p2(rule, pwd)
        println("VALID $rule $pwd")
    else
        println("INVALID $rule $pwd")
    end
end

nvalid = sum(map(p -> matches_p2(p[1], p[2]), lst))
println("$nvalid passwords are valid")
