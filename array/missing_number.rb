# Time complexity O(n)
# Space complexity O(n)

def missing_number_by_xor(nums)
  missing = nums.size
  nums.each_with_index do |num, index|
    missing ^= index ^ num
  end
end

# Time complexity O(n), sum method loop through with every element
# Space complexity O(n)
def missing_number_with_formula(nums)
  num_size = nums.size
  sum_of_n_natural_number = num_size * (num_size + 1) / 2
  sum_of_n_natural_number - nums.sum
end

# Time complexity O(n^2) loop inside loop
# Space complexity O(n)
def missing_number(nums)
  (0..nums.size).each do |num|
    return num unless nums.include?(num)
  end
end
