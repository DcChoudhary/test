# frozen_string_literal: true

require 'logger'
require_relative './library'

##
# This class execute the given command
#
class CommandProcessor
  class InvalidCommandError < StandardError; end

  def initialize
    @lib = Library.instance
    @logger = Logger.new($stdout)
  end

  def process(command, args)
    case command
    when 'create_library'
      lot_id, rack_size = *args
      @lib.configure(lot_id)
      @lib.add_racks(rack_size.to_i)
    when 'add_book'
      @logger.info("ARGS--> #{args}")
      @lib.add_book(*args)
    when 'status'
      @lib.status
    else
      raise InvalidCommandError, 'Invalid command'
    end
  rescue InvalidCommandError, Library::RackOutOfBoundError => e
    puts "ERROR: #{e.message}"
  end
end
