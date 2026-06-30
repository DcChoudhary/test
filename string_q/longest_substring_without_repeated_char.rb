#rubocop:disable all
# https://leetcode.com/problems/longest-substring-without-repeating-characters

# This solution uses the sliding window pattern
# increase the right pointer until any duplicate char in the hash.
# increase the left until the char in the hash count > 1 to shrink the window
# after every iteration we update the max_length

# abcabcbb
def length_of_longest_substring(s)
  max_count = 0
  hash = Hash.new(0)
  left = 0
  right = 0

  while(right < s.length)
    char = s[right]
    hash[char] += 1

    while(hash[char] > 1)
      hash[s[left]] -= 1
      left +=1
    end

    max_count = [max_count, right - left + 1].max
    right += 1
  end
  max_count
end



s = 'abcabcbb'
length_of_longest_substring(s)