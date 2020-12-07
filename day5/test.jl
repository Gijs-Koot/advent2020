include("code.jl")

using Test

@test seqbinsum("BFFFBBF", "B") == 70

@test seatid("BFFFBBFRRR") == 567
@test seatid("FFFBBBFRRR") == 119
@test seatid("BBFFBBFRLL") == 820


@test missing(Set([1, 2, 4, 5, 8])) == Set([3, 6, 7])

@test holes(Set([1, 2, 4, 5, 8])) == Set([3])
