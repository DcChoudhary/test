# frozen_string_literal: true

##
# This class hold the properties of user
#
class User
  attr_reader :id, :borrowed_copies

  MAX_BORROW_COPIES = 5

  def initialize(id)
    @id = id
    @borrowed_copies = []
  end

  def borrow(copy)
    @borrowed_copies << copy
  end

  def borrowed?(copy)
    borrowed_copies.any? { |borrowed_copy| borrowed_copy.id == copy.id }
  end

  def return_copy(copy)
    @borrowed_copies.delete(copy)
  end
end
