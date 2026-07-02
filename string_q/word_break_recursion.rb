# https://leetcode.com/problems/word-break

# This solution uses recursion without memoization,
# so it is not a optimal solution, for the big string it will run for long time

# Time complexity is O(2^n)
# Space is O(1)

def word_break(str, arr)
  set = arr.to_set
  check_str(str, 0, set)
end

def check_str(str, start, set)
  return true if start == str.length

  (start..str.length).each do |index|
    word = str[start..index]

    return true if set.include?(word) && check_str(str, index + 1, set)
  end
  false
end

str = 'leetcode'
arr = %w[leet code]
word_break(str, arr)

str = 'catsandog'
arr = %w[cat cats sand and dog]
word_break(str, arr)

str = 'leetcode', start = 0, set = %w[leet, code]
l
le
lee
leet #=> true

str = 'leetcode',
      start = index + 1 #=> 4
set = %w[leet, code]

c
co
cod
code #=> true
