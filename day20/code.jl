using Test
using DataStructures

struct Tile
    id
    arr
end

function parsetile(lines)

    id = parse(Int, split(lines[ix], " ")[2][1:end-1]) 
    arr = hcat([[c == '#' for c in l] for l in lines[ix+1:ix+10]]...)

    Tile(id, arr)
end

function readtiles(fn)

    lines = readlines(fn)
    tiles = Vector{Tile}()
    for ix in findall(startswith.(lines, "Tile"))
        tile = parsetile(lines[ix:ix+10])
        push!(tiles, tile)
    end
    tiles

end

tiles = readtiles("./data/example")

function borders(tile)
    # top bottom left right
    Dict("T" => tile.arr[1,:],
         "B" => tile.arr[10,:],
         "L" => tile.arr[:,1],
         "R" => tile.arr[:,10])
end

@test length(collect(values(borders(tile)))) == 4

function rotate(arr::Array{Bool, 2})::Array{Bool, 2}
    n = size(arr)[1]
    [arr[n-y+1, x] for x in 1:n, y in 1:n]
end

function vflip(arr::Array{Bool, 2})::Array{Bool, 2}
    n = size(arr)[1]
    [arr[n+1-x, y] for x in 1:n, y in 1:n]
end

function hflip(arr::Array{Bool, 2})::Array{Bool, 2}
    n = size(arr)[1]
    [arr[x, n+1-y] for x in 1:n, y in 1:n]
end

@test rotate(tile.arr) != tile.arr
@test rotate(rotate(tile.arr)) != tile.arr
@test rotate(rotate(rotate(rotate(tile.arr)))) == tile.arr

@test hflip(hflip(tile.arr)) == tile.arr
@test sum(hflip(tile.arr)) == sum(tile.arr)
@test hflip(tile.arr)[1, 1] == tile.arr[10, 1]
@test vflip(tile.arr)[1, 1] == tile.arr[1, 10]


function combs(tiles)
    dd = DefaultDict{Vector{Bool}, Vector{Int}}([])
    for tile in tiles
        for border in values(borders(tile))
            push!(dd[border], tile.id)
            push!(dd[reverse(border)], tile.id)
        end
    end

    dd
end

dd = combs(tiles)
singles = reduce(vcat, [s for s in values(dd) if length(s) == 1])
corners = [i for (i, v) in countmap(singles) if v == 4]

@test prod(corners) == 20899048083289

itiles = readtiles("./data/input")

# check if the same idea works
countmap(length.(values(combs(itiles))))
dd = combs(itiles)
singles = reduce(vcat, [s for s in values(dd) if length(s) == 1])
corners = [i for (i, v) in countmap(singles) if v == 4]

ans = prod(corners)

tiles = Dict(tile.id => tile for tile in itiles)
start = tiles[first(corners)]

# luckily, only one image every matches so ok

for corner in corners
    for (d, b) in borders(tiles[corner])
        println(d, dd[b])
    end
end

# from this it follows this 1657 is top left

TL = tiles[1657]

taken = Set{Int}()
push!(taken, 1657)

function permutations(tile)
    res = Set{Tile}()
    arr = tile.arr
    for irot in 1:4
        arr = rotate(arr)
        push!(res, Tile(tile.id, arr))
        push!(res, Tile(tile.id, flip(arr)))

    end
    res
end

@test length(permutations(tiles[1657])) == 8

function findtile(direction, border, choices)
    for tile in choices
        for perm in permutations(tile)
            if borders(perm)[direction] == border
                return perm
            end
        end
    end
end

function fillmat()
    mat = Array{Tile, 2}(undef, 12, 12)
    mat[1, 1] = tiles[1657]

    ir = 0
    ic = 1
    
    taken = Set{Int}()
    push!(taken, 1657)
    
    while true # row
        ir += 1
        if length(taken) == length(tiles)
            break
        end
        while true # col
            ic += 1
            
            choices = Set([t for (i, t) in tiles if !(i ∈ taken)])
            if ic == 1
                if ir > 1
                    topb = borders(mat[ir-1, ic])["B"]
                    fitted = findtile("T", topb, choices)

                    mat[ir, ic] = fitted
                    push!(taken, fitted.id)
                end
            else
                leftb = borders(mat[ir, ic-1])["R"]
                fitted = findtile("L", leftb, choices)
                if isnothing(fitted)
                    ic = 0
                    break
                end # next row
                mat[ir, ic] = fitted
                push!(taken, fitted.id)
            end
        end
    end
    mat
end

mat = fillmat()    

# fill in the whole image

image = Array{Bool, 2}(undef, 96, 96)

for ir in 1:12
    for ic in 1:12
        f = mat[ir, ic].arr[2:9,2:9]
        image[(ir-1)*8+1:ir*8,(ic-1)*8+1:ic*8] = f
    end
end

function parsemat(fn)
    collect(hcat([[c == '#' for c in l] for l in readlines(fn)]...)')
end

monster = parsemat("./data/monster")
testimg = parsemat("./data/testimg")

function monsterixs(r, c)
    res = Vector{CartesianIndex}()
    for ix in findall(monster)
        ir, ic = ix.I
        push!(res, CartesianIndex(ir+r-1, ic+c-1))
    end
    res
end

function findmonsters(img)
    res = Vector{Tuple{Int, Int}}()
    h, w = size(img)
    for c in 1:(w-20+1)
        for r in 1:(h-3+1)
            if all(img[ix] for ix in monsterixs(r, c))
                push!(res, (r, c))
            end
        end
    end
    res
end

@test findmonsters(monster) == [(1, 1)]

function findmonsterperm(img)
    imgc = copy(img)
    for i in 1:4
        imgc = rotate(imgc)
        for j in 1:2
            imgc = vflip(imgc)
            res = findmonsters(imgc)
            if length(res) > 0
                return res, imgc
            end
        end
    end
end

findmonsters(testimg)
locs, img = findmonsterperm(testimg)

@test length(loc) == 2

function countremains(img)
    locs, img = findmonsterperm(img)
    for (r, c) in locs
        for ix in monsterixs(r, c)
            img[ix] = 0
        end
    end
    return sum(img)
end

@test countremains(testimg) == 273

countremains(image)


