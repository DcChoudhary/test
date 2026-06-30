# rubocop:disable all

# two sum on unsorted array
# https://leetcode.com/problems/two-sum


def two_sum(nums, target)
  ele = {}
  nums.each_with_index do |num, index|
    remainder = target - num
    return [ele[remainder], index] if ele.key?(remainder)

    ele[num] = index
  end
  nil
end

arr = [2,7,11,15]
two_sum(arr, 9)