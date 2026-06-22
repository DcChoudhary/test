# frozen_string_literal: true

require 'set'

module StringQ
  ##
  # This class reverse the vowels from the given string using two pointer
  # left and right pointer will both will move in the opposite direction untill
  # vowel char not found if both found the vowel we will swap them with each other.
  class ReverseVowelsTwoPointer
    VOWELS = Set.new(%w[a e i o u A E I O U]).freeze

    ##
    # Reverses only vowels characters from the given string, leaving all other charaters on there original places
    #
    # @params[]

    def reverse_vowels(str)
      initialize_variables(str)
      traverse_str
      @str
    end

    private

    def initialize_variables(str)
      @left = 0
      @right = str.size - 1
      @str = str
    end

    def traverse_str
      while @left < @right
        if left_vowel? && right_vowel?
          swap_and_move
        elsif !left_vowel?
          @left += 1
        else
          @right -= 1
        end
      end
    end

    def swap_and_move
      @str[@left], @str[@right] = @str[@right], @str[@left]
      @left += 1
      @right -= 1
    end

    def left_vowel?
      VOWELS.include?(@str[@left])
    end

    def right_vowel?
      VOWELS.include?(@str[@right])
    end
  end
end
