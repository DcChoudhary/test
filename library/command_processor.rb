# frozen_string_literal: true

require 'logger'
require_relative './library'

##
# This class execute the given command
#
class CommandProcessor
  class InvalidCommandError < StandardError; end

  COMMANDS = {
    'create_library' => lambda { |args|
      lot_id, rack_size = *args
      @lib.configure(lot_id)
      @lib.add_racks(rack_size.to_i)
    },
    'add_book' => ->(args) { @lib.add_book(*args) },
    'stauts' => -> { @lib.status }
  }.freeze

  def initialize
    @lib = Library.instance
    @logger = Logger.new($stdout)
  end

  def process(command, args)
    @logger.info('Start processing command...')
    raise InvalidCommandError, 'Invalid command' if COMMANDS[command]&.call
  rescue InvalidCommandError, Library::RackOutOfBoundError, Rack::BookAlreadyPresentError => e
    puts "ERROR: #{e.message}"
  end
end
