# frozen_string_literal: true

require 'logger'
require_relative 'parking_lot'

##
# This class is responsible for processing the commands
#
class CommandProcessor
  class InvalidCommandError < StandardError; end

  def initialize
    @lot = ParkingLot.instance
    @logger = Logger.new($stdout)
  end

  def process(command, args)
    @logger.info("command ---- #{command} with args #{args}")

    display = {
      color: 'vehicles_with_color',
      plate: 'vehicle_with_plate'
    }

    case command
    when 'cpl' # cpl means create_parking_lot
      create_floors_and_spots(*args)
    when 'park_vehicle'
      @lot.park(*args)
    when 'unpark_vehicle'
      @lot.unpark(*args)
    when 'display'
      @lot.public_send(display[args[0].to_sym], args[1])
    when 'status'
      @lot.status
    else
      raise InvalidCommandError, 'Command not found'
    end
  end

  private

  def create_floors_and_spots(lot_id, floors, spots)
    @lot.configure(lot_id)
    floors.to_i.times do |floor_index|
      floor = Floor.new("F#{floor_index}")
      @lot.add_floor(floor)
      spots.to_i.times { |spot_index| floor.add_spot("#{floor.floor_number}-S#{spot_index}") }
    end
  end
end
