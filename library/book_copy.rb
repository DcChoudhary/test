# frozen_string_literal: true

##
# This class is responsible to manage the book copies
#
class BookCopy
  attr_reader :id, :book, :user, :due_date

  class MaxBorrowingCapacityReachError < StandardError; end
  class CopyAlreadyBorrowedError < StandardError; end

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
      raise MaxBorrowingCapacityReachError, "User already borrowed #{User::MAX_BORROW_COPIES}"
    end

    raise CopyAlreadyBorrowedError, 'User already borrowed the book' if user.borrowed?(self)

    @user = user
    @due_date = Time.parse(due_date).to_date
  end
end
