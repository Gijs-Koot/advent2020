expr = "1 + 2 * 3 + 4 * 5 + 6"
expr = "1 + (2 * 3) + (4 * (5 + 6))"

using Test

PAREX = r"\(([^\(\).]*)\)"
NUMEX = r"^[\d]$"
OPEX = r"^(-?\d+) ([+*]) (-?\d+)"

function eval(expr)

    # cleanup for lazy 
    expr = strip(expr)
    expr = replace(expr, r" +" => " ")

    # if atom then done
    if !isnothing(match(r"^-?[\d]+$", expr))
        return parse(Int64, expr)
    end

    # then unpack outside parens
    matc = findall(PAREX, expr)
    if length(matc) > 0

        f = first(matc[1])
        l = last(matc[1])
        subexpr = expr[f+1:l-1]
        res = eval(subexpr)
        return eval("$(expr[1:f-1])$(res)$(expr[l+1:end])")
    end

    # eval first operator on left
    m = match(OPEX, expr)
    len = length(m.match)
    a = parse(Int64, m[1])
    b = parse(Int64, m[3])
    res = m[2] == "*" ? a * b : m[2] == "+" ? a + b : a - b

    if length(res) == length(expr)
        return res
    end
    return eval("$res $(expr[len+1:end])")
end

@test eval("13") == 13
@test eval("(14)") == 14
@test eval("(12 + 12) + (2 * 3)") == 30
@test eval("1 + 2 * 3 + 4 * 5 + 6") == 71

@test eval("1 + (2 * 3) + (4 * (5 + 6))") == 51

# part I

lines = readlines("./data/input")
ans = sum(eval.(lines))

# part II

PAREX = r"\(([^\(\).]*)\)"
NUMEX = r"^[\d]$"
ADDEX = r"(-?\d+) \+ (-?\d+)"
MULEX = r"^(-?\d+) \* (-?\d+)"

x = if 1 == 1
    return true
else
    false
end
    
function eval2(expr)

    # cleanup for lazy 
    expr = strip(expr)
    expr = replace(expr, r" +" => " ")
    # if atom then done
    if !isnothing(match(r"^-?[\d]+$", expr))
        return parse(Int64, expr)
    end

    # then unpack outside parens
    matc = findall(PAREX, expr)
    if length(matc) > 0

        f = first(matc[1])
        l = last(matc[1])
        subexpr = expr[f+1:l-1]
        res = eval2(subexpr)
        return eval2("$(expr[1:f-1])$(res)$(expr[l+1:end])")
    end

    # eval first operator on left
    m = match(ADDEX, expr)
    res, len, offset = 0, 0, 0
    if !isnothing(m)
        a = parse(Int64, m[1])
        b = parse(Int64, m[2])
        res = a + b
    else
        m = match(MULEX, expr)
        a = parse(Int64, m[1])
        b = parse(Int64, m[2])
        res, len = a * b, length(m.match)
    end

    nxt = replace(expr, m.match => "$res", count=1)
    return eval2(nxt)
end

@test eval2("5 + 4") == 9
@test !isnothing(match(ADDEX, "5 + 4"))
@test eval2("1 + 2 * 3 + 4 * 5 + 6") == 231
@test eval2("1 + (2 * 3) + (4 * (5 + 6))") == 51
@test eval2("2 * 3 + (4 * 5)") == 46
@test eval2("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 669060

res = eval2.(lines)
sum(res)
