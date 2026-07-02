# https://leetcode.com/problems/3sum

# Sort the array
# Fixed one number
# Now using two pointer find the other two numbers
# If the sum of all the 3 number fixed, left pointer, right pointer is 0 add this to the result array

# Time complexity O(n^2)
# Space complexity O(1)

def three_sum(nums)
  return [] if nums.size < 3

  nums.sort!
  results = []
  (0..nums.size - 3).each do |index|
    # early exit array is sorted so if the number is positive then
    # we can not find the number whose sum is equal to zero
    break if nums[index].positive?
    next if index.positive? && nums[index] == nums[index - 1]

    find_triplets(nums, index, results)
  end
  results
end

def find_triplets(nums, index, results)
  left = index + 1
  right = nums.size - 1

  while left < right
    total = nums[index] + nums[left] + nums[right]

    if total.zero?
      results << [nums[index], nums[left], nums[right]]
      left += 1
      right -= 1
      left += 1 while left < right && nums[left] == nums[left - 1]
      right -= 1 while left < right && nums[right] == nums[right + 1]
    elsif total.negative?
      left += 1
    else
      right -= 1
    end
  end
end

nums = [-1, 0, 1, 2, -1, -4]
# [-4, -1, -1, 0, 1, 2]
three_sum(nums)
