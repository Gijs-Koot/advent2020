x = open(io -> read(io, String), "input.txt")
y = map(s -> parse(Int, x[s.offset+1:s.offset+s.ncodeunits]), split(strip(x), "\n"))

for (ix, a) in enumerate(y)
    for (iy, b) in enumerate(y[ix:end])
        for (iz, c) in enumerate(y[iy:end]) 
            if (a + b + c) == 2020
                println("$a + $b + $c = $(a + b + c), combining lines $ix, $(ix + iy - 1) and $(ix + iy + iz - 2)")
                println("$a * $b * $c= $(a * b * c)")
            end
        end
    end
end
