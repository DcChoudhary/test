# https://leetcode.com/problems/longest-palindromic-substring/

# We uses the around center method to find it

# cbbd
def longest_palindrome(str)
  max_length = 1
  start = 0

  i = 0
  while i < str.size
    start, max_length = expand(s, i, i, start, max_length)
    start, max_length = expand(s, i, i + 1, start, max_length)
    i += 1
  end
  str[start, max_length]
end

def expand(str, left, right, start, max_length)
  while left >= 0 && right < str.size && str[left] == str[right]

    current_length = right - left + 1

    if current_length > max_length
      start = left
      max_length = current_length
    end

    left -= 1
    right += 1
  end

  [start, max_length]
end
