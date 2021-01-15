using Test

function transform(subject_number, loop_size)
    x = 1
    for _ in 1:loop_size
        x *= subject_number
        x = x % 20201227
    end
    x
end

@test transform(7, 8) == 5764801

# brute force ?

function transforms(subject_number, loop_size_max, look_for)
    x = 1
    for loop_size in 1:loop_size_max
        x *= subject_number
        x = x % 20201227
        if x == look_for
            return loop_size
        end
    end
end

@test transforms(7, 10, 5764801) == 8

card_public = 13135480
door_public = 8821721

card_loop_size = transforms(7, 100000000000, card_public)
door_loop_size = transforms(7, 100000000000, door_public)

transform(card_public, door_loop_size)
transform(door_public, card_loop_size)    


