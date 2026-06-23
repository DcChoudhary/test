# frozen_string_literal: true

##
# This class is responsible to manage the book copies
#
class BookCopy
  attr_reader :id, :book

  def initialize(id, book)
    @id = id
    @book = book
  end

  def display
    puts "Copy #{id} of Book #{book.title}"
  end
end
