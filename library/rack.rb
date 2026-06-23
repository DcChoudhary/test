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

  def remove_copy(copy)
    @copies.delete(copy)
  end

  def find_copy(copy_id)
    logger = Logger.new($stdout)
    logger.info("copies --> #{copies.inspect}")
    logger.info("copy_id --> #{copy_id}")
    copies.find { |copy| copy.id == copy_id }
  end

  def available_for?(book)
    copies.none? { |copy| copy.book.id == book.id }
  end

  def to_s
    "Rack #{id} has #{copies.size} copies"
  end
end
