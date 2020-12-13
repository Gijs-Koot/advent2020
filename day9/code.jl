nums = parse.(Int, open(readlines, "../data/day9/input"))

function issumin(num, nums)
    for ix in range(1, length = length(nums))
        compl = num - nums[ix]
        if (compl ∈ nums[1:ix-1]) | (compl ∈ nums[ix+1:end])
            return true
        end
    end
    return false
end

for (ix, num) in enumerate(nums)
    available = nums[max(ix-26, 1):ix-1]
    if !issumin(nums[ix], available)
        println("$ix $num not in $available")
    end
end




function findconseq()

    invalid_line = 591
    invalid_number = 248131121    

    for ix in range(1, length=invalid_line)
        for iy in range(1, length=invalid_line-ix)
            total = sum(nums[ix:ix+iy])
            
            if total == invalid_number
                println("$ix $iy")
                return
            elseif total > invalid_number
                break
            end
        end
    end
end
