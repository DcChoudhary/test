# frozen_string_literal: true

##
# This class is responsible for holding the books
#
class Rack
  class BookAlreadyPresentError < StandardError; end

  attr_reader :id

  def initialize(id)
    @id = id
    @copies = []
  end

  def add_book(copy)
    copy = @copies.any? { |copy| copy.id == id }
    raise BookAlreadyPresentError, "Book with #{copy.id} already present on the shelf" if copy

    @copies << copy
  end

  def display
    puts "Rack #{id} has #{copies.size} copies"
  end
end
