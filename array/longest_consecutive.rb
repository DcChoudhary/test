# rubocop:disable all

# brute force approach
# Iterate with each element and check it there is any current + 1 present then length + 1
# we keep count of the longest consecutive numbers, because there are couple of consecutive sequences present in the array.
# we always update te longest if the current sequence length is greater then the last sequence because we need to find the longest sequence

## Time complexity O(n^2)
def longest_consecutive(arr)
  return 0 if arr.nil? || ar.empty?

  longest = 0

  arr.each do |current|
    length = 1

    while arr.include?(current + 1)
      length += 1
      current += 1
    end

    longest = [longest, length].max
  end
  longest
end

arr = [102, 101, 100, 102, 4, 200, 1, 3, 2]
longest_consecutive(arr)

102
longest = 1
current = 102
longest = [1, 0].max #=> 1

101
length = 1, 2
current = 102, 103
longest = [2, 2].max #=> 2

100
length = 1, 2, 3
current 100, 101, 102
longest = [3, 2].max #=> 3

102
length = 1
current = 102
longest = [1, 3].max #=> 3

4
length = 1
current = 4
longest = [1, 3].max #=> 3

200
length = 1
current = 200
longest = [1, 3].max #=> 3

1
length = 1, 2, 3, 4
current = 1, 2, 3, 4
longest = [4, 4].max #=> 4

3
length = 1, 2
current = 3, 4
longest = [2, 4].max #=> 4

2
length = 1, 2, 3
current = 2, 3, 4
longest = [3, 4] #=> 4

longest #=> 4

# Better approach with sorting O(nlogn)
# First sort and find the longest consecutive sequence

# Time complexity: (nlogn)
# Space : 0(1)
def longest_consecutive_sort(arr)
  return 0 if arr.nil? || arr.empty?

  arr.sort!
  # [1, 2, 3, 4, 100, 101, 102, 102, 200]
  longest = 1
  current = 1

  (1..arr.size).each do |i|
    next if arr[i] == arr[i - 1] # duplicate element skip it
      
    if arr[i] == arr[i - 1] + 1 # current element is greater then the previous one
      current += 1
    else
      current = 1
    end
    longest = [current, longest].max
  end
  longest
end

arr = [102, 101, 100, 102, 4, 200, 1, 3, 2]
longest_consecutive_sort(arr)



# Optimal approach either use the hash or set, 
# which will remove the duplicate numbers from the array, 
# then find the starting point of the sequence and find the grater number by
# current + 1 if present update the longest if the longest is less then the length

# Time complexity: O(n)
# Space: O(n)

require 'set'

def longest_consecutive_using_set(arr)
  set = arr.to_set

  longest = 0

  set.each do |num|
    next if set.include?(current - 1)

    length = 1
    current = num

    while(set.include?(current + 1))
      length += 1
      current += 1
    end

    longest = [length, longest].max
  end
  longest
end
