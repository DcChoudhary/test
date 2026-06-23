# frozen_string_literal: true

require 'logger'
require_relative './library'

##
# This class execute the given command
#
class CommandProcessor
  class InvalidCommandError < StandardError; end

  ALLOWED_COMMANDS = %w[create_library add_book remove_book_copy borrow_book borrow_book_copy status].freeze

  def initialize
    @lib = Library.instance
    @logger = Logger.new($stdout)
  end

  def process(command, args)
    @logger.info('Start processing command...')
    raise InvalidCommandError, 'Invalid Command' unless ALLOWED_COMMANDS.include?(command)

    send(command.to_sym, args)
  rescue InvalidCommandError, Library::RackOutOfBoundError, Rack::BookAlreadyPresentError,
         Library::NoBookCopyFoundError, BookCopy::MaxBorrowingCapacityReachError,
         BookCopy::CopyAlreadyBorrowedError, Book::NoBookAvailableError => e
    puts "ERROR: #{e.message}"
  end

  private

  def create_library(args)
    lot_id, rack_size = *args
    @lib.configure(lot_id)
    @lib.add_racks(rack_size.to_i)
  end

  def add_book(args)
    id, title, authors, publishers, copy_ids = *args
    @lib.add_book(id, title, authors.split(','), publishers.split(','), copy_ids.split(','))
  end

  def remove_book_copy(args)
    @lib.remove_book_copy(*args)
  end

  def borrow_book(args)
    @lib.borrow_book(args)
  end

  def status(_)
    @lib.status
  end
end
