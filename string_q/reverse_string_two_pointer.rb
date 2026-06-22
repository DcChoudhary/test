# frozen_string_literal: true

module StringQ
  ##
  # Reverse the input string using the two pointer pattern
  class ReverseStringTwoPointer
    def reverse_string(str)
      # Return string if that is nil? or it has only one character
      return str if str.size <= 1

      left = 0
      right = str.size - 1

      while left < right
        str[left], str[right] = str[right], str[left]

        left += 1
        right -= 1
      end

      str
    end
  end
end
