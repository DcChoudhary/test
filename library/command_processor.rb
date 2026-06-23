# frozen_string_literal: true

require_relative './library'

##
# This class execute the given command
#
class CommandProcessor
  class InvalidCommandError < StandardError; end

  def initialize
    @lib = Library.new
  end

  def process(command, *args)
    case command
    when 'create_library'
      @lib.configure(args[0])
      @lib.add_racks(args[1])
    when 'add_book'
      @lib.add_book(*args)
    when status
      @lib.status
    else
      raise InvalidCommandError, 'Invalid command'
    end
  rescue InvalidCommandError, Library::RackOutOfBoundError => e
    puts "ERROR: #{e.message}"
  end
end
