# frozen_string_literal: true

##
# This class hold the details of book and book related operation
#
class Book
  def initialize(id, title, author, publisher)
    @id = id
    @title = title
    @author = author
    @publisher = publisher
    @book_copies = []
  end

  def add_copy(copy)
    @book_copies << copy
  end
end
