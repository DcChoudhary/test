# https://leetcode.com/problems/valid-palindrome

# Time Complexity O(n)
# Space complexity O(1)
def palindrome?(str)
  str.downcase!
  str.gsub!(/[^a-z0-9]/, '')
  left = 0
  right = s.size - 1

  while left <= right
    return false if str[left] != str[right]

    left += 1
    right -= 1
  end
  true
end

def palindrome_without_removing?(str)
  left = 0
  right = str.size - 1

  while left < right
    left += 1 while left < right && !alphanumeric?(str[left])
    right -= 1 while left < right && !alphanumeric?(str[right])

    return false if str[left].downcase != str[right].downcase

    left += 1
    right -= 1
  end
  true
end

def alphanumeric?(char)
  char&.match?(/[a-zA-Z0-9]/)
end

str = 'A man, a plan, a canal: Panama'
palindrome_without_removing?(str)
