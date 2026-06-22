# frozen_string_literal: true

module StringQ
  ##
  # Cleans extra spaces in-place using two pointers directly on the string.
  class RemoveExtraSpaces
    ##
    # @param str [String] a mutable (unfrozen) string
    # @return [String] the same string object, spaces cleaned
    def remove_spaces(str)
      initialize_variables(str)

      clean_leading_spaces

      while @read < @size
        @str[@read] != ' ' ? copy_valid_char : clean_consecutive_spaces
      end
      clean_trailing_spaces

      # Truncate the @string to the valid written length
      @str[@write..] = ''

      @str
    end

    private

    def initialize_variables(str)
      @str = str
      @read = 0
      @write = 0
      @size = str.size
    end

    def clean_leading_spaces
      # Skip leading spaces
      @read += 1 while @read < @size && @str[@read] == ' '
    end

    def clean_trailing_spaces
      # Trim trailing space
      @write -= 1 if @write.positive? && @str[@write - 1] == ' '
    end

    def clean_consecutive_spaces
      @str[@write] = ' '
      @write += 1
      @read += 1 while @read < @size && @str[@read] == ' '
    end

    def copy_valid_char
      @str[@write] = @str[@read]
      @write += 1
      @read += 1
    end
  end
end

str = String.new(' Hello    World   .')
obj = StringQ::RemoveExtraSpaces.new
puts obj.remove_spaces(str)
