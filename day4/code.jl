function readpps(fn)
    return open(fn) do io
        return map(strip, split(read(io, String), "\n\n"))
    end
end

function elements(pp)
    return Set(map(s -> convert(String, split(s, ":")[1]), split(pp, r"\n| ")))
end

function pairs(pp)
    return Dict(split.(strip.(split(pp, r"\n| ")), ":"))
end

function valid(pair)
    for (key, func) in CHECKS
        try
            if !func(pair[key])
                println("$key INVALID $(pair[key])")
                return false
            end
            println("$key VALID $(pair[key])")
        catch
            return false
        end
    end
    return true
end

REQUIRED = Set(["hcl", "ecl", "pid", "iyr", "eyr", "hgt", "byr"])

function validheight(s)
    if endswith(s, "cm")
        return 150 <= parse(Int, s[1:(end-2)]) <= 193
    elseif endswith(s, "in")
        return 59 <= parse(Int, s[1:(end-2)]) <= 76
    end
    return false
end

EYE_COLORS = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])

CHECKS = Dict(
    "byr" => s -> 1920 <= parse(Int, s) <= 2002,
    "iyr" => s -> 2010 <= parse(Int, s) <= 2020,
    "eyr" => s -> 2020 <= parse(Int, s) <= 2030,
    "hgt" => validheight,
    "hcl" => s -> match(r"^#[0-9a-f]{6}$", s) != nothing,
    "ecl" => s -> s ∈ EYE_COLORS,
    "pid" => s -> match(r"^\d{9}$", s) != nothing
)
