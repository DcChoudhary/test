# frozen_string_literal: true

module StringQ
  ##
  # Reverses the order of words in a string using a two-pointer approach.
  # Leading/trailing whitespace is ignored and multiple spaces are collapsed.
  class ReverseWordTwoPointer
    def reverse_words(str)
      words = str.split

      left = 0
      right = words.size - 1

      while left < right
        words[left], words[right] = words[right], words[left]

        left += 1
        right -= 1
      end

      words.join(' ')
    end
  end
end
