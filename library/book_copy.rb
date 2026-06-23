# frozen_string_literal: true

require 'time'

##
# This class is responsible to manage the book copies
#
class BookCopy
  attr_reader :id, :book, :user, :due_date

  class MaxBorrowingCapacityReachError < StandardError; end
  class CopyAlreadyBorrowedError < StandardError; end
  class CopyNotAssignedError < StandardError; end

  def initialize(id, book)
    @id = id
    @book = book
    @user = nil
    @due_date = nil
  end

  def to_s
    "Copy #{id} of Book #{book.title}"
  end

  def available?
    due_date.nil?
  end

  def borrow(user, due_date)
    if user.borrowed_copies.size >= User::MAX_BORROW_COPIES
      raise MaxBorrowingCapacityReachError, "User already borrowed #{User::MAX_BORROW_COPIES} books"
    end

    raise CopyAlreadyBorrowedError, 'User already borrowed the book' if user.borrowed?(self)

    @user = user
    @due_date = Time.parse(due_date).to_date
    user.borrow(self)
    self
  end

  def return_copy
    raise CopyNotAssignedError, "Copy #{id} is not assigned to any user" unless user || due_date

    user.return_copy(self)
    @user = nil
    @due_date = nil

    puts "Returned book #{book.id} with copy id #{id}"
  end
end
