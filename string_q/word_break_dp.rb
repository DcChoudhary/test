# https://leetcode.com/problems/word-break

# This uses recursion with memoization(DP)

# leetcode
def word_break(str, words_arr)
  memo = {}
  set = words_arr
  check_str(str, 0, set, memo)
end

def check_str(str, start, set, memo)
  return true if start == str.length

  return memo[start] if memo.key?(start)

  (start...str.length).each do |index|
    word = str[start..index]

    if set.include?(word) && check_str(str, index + 1, set, memo)
      memo[start] = true
      return true
    end
  end
  memo[start] = false
  false
end
