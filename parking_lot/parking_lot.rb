# frozen_string_literal: true

require 'singleton'
require_relative 'floor'
require_relative 'spot'
require_relative 'vehicle'
require_relative 'ticket'

##
# This class is reposnsible to handle all the operations for the parking lot
# add_floor
# parking lot status
# fetch vehicle list with the color
# fetch vehicle with the vehicle plate
#
class ParkingLot
  include Singleton
  attr_reader :floors, :lot_id

  class SpotNotAvailableError < StandardError; end
  class VehicleNotFoundError < StandardError; end
  class LotIdAlreadyConfigureError < StandardError; end

  def initialize
    @floors = []
    @tickets = {}
    @lot_id = nil
  end

  def configure(lot_id)
    raise LotIdAlreadyConfigureError, 'Lot id is already configured' if @lot_id

    @lot_id = lot_id
  end

  def add_floor(floor)
    @floors << floor
    self
  end

  def park(vehicle_plate, color)
    _, spot = find_spot_by_plate(vehicle_plate)
    raise ArgumentError, "Vehicle with #{vehicle_plate} already parked!" if spot

    spot = find_free_spot
    raise SpotNotAvailableError, 'Parking lot is full' unless spot

    vehicle = Vehicle.new(vehicle_plate, color)
    ticket = Ticket.new(vehicle, spot, Time.now)
    @tickets[ticket.id] = ticket
    spot.park!(vehicle)
    puts "Vehicle #{vehicle.plate} is parked at #{spot.spot_id} with ticket number #{ticket.id}"
  end

  def unpark(ticket_id)
    ticket = @tickets[ticket_id]
    unless ticket
      raise VehicleNotFoundError,
            "No Vehicle parked with ticket id #{ticket_id}"
    end

    vehicle = ticket.vehicle
    ticket.close!
    puts "Unpark a vehicle with vehicle plate #{vehicle.plate}, and color #{vehicle.color}"
  end

  def vehicles_with_color(color)
    spot_details = find_spots_for_vehicle_color(color)
    if spot_details.empty?
      puts "No vehicle found with color #{color}"
    else
      puts "Vehicle detail with color #{color}"
      spot_details.each do |spot_detail|
        floor, spot = spot_detail
        vehicle_plate = spot.vehicle.plate
        puts "Vehicle plate #{vehicle_plate} is parked on floor #{floor.floor_number} at spot #{spot.spot_id}"
      end
    end
  end

  def vehicle_with_plate(vehicle_plate)
    floor, spot = find_spot_by_plate(vehicle_plate)
    if spot.nil?
      puts 'This vehicle is not parked in the parking lot'
    else
      puts "Vehicle #{vehicle_plate} is parked on floor #{floor.floor_number} at spot #{spot.spot_id}"
    end
  end

  def status
    puts '=' * 50
    puts "Parking lot #{lot_id} and has #{floors.size} floors"
    puts '=' * 50

    floors.each(&:status)
  end

  private

  def find_free_spot
    @floors.each do |floor|
      spot = floor.free_slot
      return spot if spot
    end
    nil
  end

  def find_spot_by_plate(plate)
    @floors.each do |floor|
      spot = floor.find_spot_by_plate(plate)
      return [floor, spot] if spot
    end
    [nil, nil]
  end

  def find_spots_for_vehicle_color(color)
    @floors.flat_map { |floor| floor.find_spot_by_color(color) }
  end
end
