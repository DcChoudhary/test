# frozen_string_literal: true

require 'singleton'
require_relative 'book'
require_relative 'rack'
require_relative 'book_copy'

##
# This class is responsible for all the operation perform on library
#
class Library
  include Singleton

  attr_reader :id, :racks

  class RackOutOfBoundError < StandardError; end

  def initialize
    @id = nil
    @racks = []
    @books = []
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
    copy_ids = copy_ids.split(',')
    authors = authors.split(',')
    publishers = publishers.split(',')
    if @racks.size < copy_ids.size
      raise RackOutOfBoundError, "There is only #{@racks.size} racks, please don't pass book copies more then that"
    end

    book = find_book(id)
    validate_available_rack(book, copy_ids) if book

    book ||= create_book(id, title, authors, publishers)
    @books << book

    copy_ids.each do |copy_id|
      rack = available_rack(book)
      @logger.info("Copy #{copy_id} adding to rack #{rack.id}")
      rack.add_copy(create_copy(copy_id, book))
    end
  end

  def display
    puts "Library #{id} has #{racks.size} racks"
  end

  def divider
    puts ['-', '+', '='].sample * 10
  end

  def status
    divider
    display
    racks.each do |rack|
      divider
      rack.display
      rack.copies.each { |copy| puts copy.book }
    end
  end

  private

  def find_book(book_id)
    @books.find { |book| book.id == book_id }
  end

  def create_book(id, title, authors, publishers)
    Book.new(id, title, authors, publishers)
  end

  def create_copy(copy_id, book)
    copy = BookCopy.new(copy_id, book)
    book.add_copy(copy)
    copy
  end

  def available_rack(book)
    rack = @racks.find { |rack| rack.copy?(book) }
    rack || @racks.first
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
