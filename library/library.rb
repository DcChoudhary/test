# frozen_string_literal: true

require 'singleton'
require 'logger'
require_relative 'book'
require_relative 'rack'
require_relative 'book_copy'
require_relative 'user'

##
# This class is responsible for all the operation perform on library
#
class Library
  include Singleton

  attr_reader :id, :racks

  class RackOutOfBoundError < StandardError; end
  class NoBookCopyFoundError < StandardError; end

  def initialize
    @id = nil
    @racks = []
    @books = []
    @users = {}
    @logger = Logger.new($stdout)
  end

  def configure(id)
    if @id
      puts 'Library is alreay configured'
      return
    end

    @id = id
  end

  def add_racks(size)
    size.times { |index| @racks << Rack.new(index + 1) }
  end

  def add_book(id, title, authors, publishers, copy_ids)
    if @racks.size < copy_ids.size
      raise RackOutOfBoundError, "There is only #{@racks.size} racks, please don't pass book copies more then that"
    end

    existing_book = find_book(id)
    validate_available_rack(existing_book, copy_ids) if existing_book

    book = existing_book || create_book(id, title, authors, publishers)
    @books << book unless existing_book

    copy_ids.each do |copy_id|
      rack = available_rack(book)
      @logger.info("Copy #{copy_id} adding to rack #{rack.id}")
      rack.add_copy(create_copy(copy_id, book))
    end
  end

  def remove_book_copy(copy_id)
    rack, copy = find_copy(copy_id)

    rack.remove_copy(copy)
    copy.book.remove_copy(copy)
  end

  def borrow_book(book_id, user_id, due_date)
    user = find_or_create_user(user_id)

    book = find_book(book_id)
    copy = book.borrow_book(user, due_date)
    puts "Copy #{copy.id} of book #{book.id} is assigned to user #{user.id}"
  end

  def borrow_book_copy(copy_id, user_id, due_date)
    user = find_or_create_user(user_id)
    _, copy = find_copy(copy_id)
    copy.borrow(user, due_date)
    puts "Copy #{copy.id} of book #{copy.book.id} is assigned to user #{user.id}"
  end

  def return_book_copy(copy_id)
    _, copy = find_copy(copy_id)
    copy.return_copy
  end

  def print_borrowed(user_id)
    user = @users[user_id]
    raise UserNotFoundError, "User not found with #{user_id}" unless user

    user.borrowed_copies.each { |copy| puts copy }
  end

  def to_s
    "Library #{id} has #{racks.size} racks"
  end

  def status
    puts self
    racks.each do |rack|
      puts rack
      rack.copies.each { |copy| puts copy.book }
    end
  end

  private

  def find_copy(copy_id)
    copy = nil
    rack = @racks.find { |rack| copy = rack.find_copy(copy_id) }
    raise NoBookCopyFoundError, "Book copy with id #{copy_id} not found" unless copy

    [rack, copy]
  end

  def find_book(book_id)
    @books.find { |book| book.id == book_id }
  end

  def find_or_create_user(user_id)
    existing_user = @users[user_id]
    user = existing_user || User.new(user_id)

    @users[user.id] = user unless existing_user
    user
  end

  def create_book(id, title, authors, publishers)
    Book.new(id, title, authors, publishers)
  end

  def create_copy(copy_id, book)
    book.add_copy(copy_id)
  end

  def available_rack(book)
    rack = @racks.find { |rack| rack.available_for?(book) }
    rack || raise(RackOutOfBoundError, "No available rack for book #{book.id}")
  end

  def validate_available_rack(book, copy_ids)
    existing_copies = book.copies.size
    total_racks = @racks.size
    return if existing_copies + copy_ids.size <= total_racks

    raise RackOutOfBoundError,
          "Book #{book.id} already has #{existing_copies} copies, total available racks are #{total_racks},
          so there are only #{total_racks - existing_copies} racks available"
  end
end
