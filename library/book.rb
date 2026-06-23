# frozen_string_literal: true

##
# This class hold the details of book and book related operation
#
class Book
  attr_reader :id, :copies, :title, :authors, :publishers

  class NoBookAvailableError < StandardError; end

  def initialize(id, title, authors, publishers)
    @id = id
    @title = title
    @authors = authors
    @publishers = publishers
    @copies = []
  end

  def add_copy(copy_id)
    copy = BookCopy.new(copy_id, self)
    @copies << copy
    copy
  end

  def remove_copy(copy)
    @copies.delete(copy)
  end

  def borrow_book(user, due_date)
    copy = available_copy
    raise NoBookAvailableError, "No copy of book #{id} available" unless copy

    copy.borrow(user, due_date)
  end

  def available_copy
    copies.find(&:available?)
  end

  def to_s
    <<~TEXT
      ---------------
      Book id: #{id}
      Title:  #{title}
      Authors: #{authors.join(',')}
      Publishers: #{publishers.join(',')}
    TEXT
  end
end
