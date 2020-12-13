struct Ship
    x
    y
    d
end

function apply(ship::Ship, rule::String)
    x = ship.x
    y = ship.y
    d = ship.d
    code = rule[1]
    value = parse(Int, rule[2:end])
    if code == 'N'
        x += value
    elseif code == 'S'
        x -= value
    elseif code == 'E'
        y += value
    elseif code == 'W'
        y -= value
    elseif code == 'L'
        d -= value
    elseif code == 'R'
        d += value
    elseif code == 'F'
        rad = (d / 360) * 2π
        y += sin(rad) * value
        x += cos(rad) * value
    end
    return Ship(x, y, d)
end

function apply(ship::Ship, rules::Array{String})
    for rule in rules
        ship = apply(ship, rule)
    end
    ship
end

function mandist(ship::Ship)
    x = round(abs(ship.x))
    y = round(abs(ship.y))
    convert(Int, x) + convert(Int, y)
end


ship = Ship(0, 0, 90)
rules = open(readlines, "./data/input")
mandist(apply(ship, rules))

# part II

struct Boat
    x::Int
    y::Int
end

struct Waypoint
    x::Int
    y::Int
end

function rads(wx, wy)
    if wx > 0
        deg = atan(wy / wx)
    elseif wx < 0
        deg = π - atan(-wy / wx)
    elseif wy > 0
        deg = π / 2
    elseif wy < 0
        deg = 3π / 2
    else
        return 0
    end
    deg
end

@test rads(0, 0) == 0
@test rads(1, 0) == 0
@test rads(2, 0) == 0
@test rads(10, 10) == π / 4
@test rads(0, -1) == 3π / 2
@test rads(0, 1) ≈ π / 2
@test rads(-1, 0) ≈ π

function rotate(wx, wy, d)

    dist = sqrt(wx ^ 2 + wy ^ 2)
    deg = rads(wx, wy)
    
    deg -= d / 360 * 2π
    
    nx = convert(Int, round(cos(deg) * dist))
    ny = convert(Int, round(sin(deg) * dist))
    nx, ny
end

@test rotate(1, 0, 90) == Tuple([0, -1])
@test rotate(1, 1, 90) == Tuple([1, -1])
@test rotate(-8, 0, 90) == Tuple([0, 8])
@test rotate(1, 1, -90) == Tuple([-1, 1])

function apply(boat::Boat, wp::Waypoint, rule::String)
    x = boat.x
    y = boat.y
    wx = wp.x
    wy = wp.y

    code = rule[1]
    value = parse(Int, rule[2:end])

    if code == 'N'
        wx += value
    elseif code == 'S'
        wx -= value
    elseif code == 'E'
        wy += value
    elseif code == 'W'
        wy -= value
    elseif code == 'L'
        wx, wy = rotate(wx, wy, value)
    elseif code == 'R'
        wx, wy = rotate(wx, wy, -value)
    elseif code == 'F'
        x += wx * value
        y += wy * value
    end

    return Boat(x, y), Waypoint(wx, wy)
end

function apply(boat::Boat, wp::Waypoint, rules::Array{String, 1})
    for rule in rules
        boat, wp = apply(boat, wp, rule)
        println(rule)
        println(boat)
        println(wp)
    end
    boat, wp
end

boat = Boat(0, 0)
wp = Waypoint(1, 10)
apply(boat, wp, rules)
