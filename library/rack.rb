# frozen_string_literal: true

##
# This class is responsible for holding the books
#
class Rack
  class BookAlreadyPresentError < StandardError; end

  attr_reader :id, :copies

  def initialize(id)
    @id = id
    @copies = []
  end

  def add_copy(copy)
    if @copies.any? { |existing_copy| existing_copy.book.id == copy.book.id }
      raise BookAlreadyPresentError, "Book with #{copy.book.id} already present on the shelf"
    end

    @copies << copy
  end

  def copy?(book)
    copies.none? { |copy| copy.book.id == book.id }
  end

  def display
    puts "Rack #{id} has #{copies.size} copies"
  end
end
