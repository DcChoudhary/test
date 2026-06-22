# frozen_string_literal: true

require 'singleton'
require_relative 'floor'
require_relative 'spot'
require_relative 'vehicle'

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
    @lot_id = nil
  end

  def configure(lot_id)
    if @lot_id
      puts 'Lot id is already configured'
      return
    end
    @lot_id = lot_id
  end

  def add_floor(floor)
    @floors << floor
    self
  end

  def park(vehicle_plate, color)
    vehicle_already_parked!

    spot = find_free_spot
    raise SpotNotAvailableError, 'Parking lot is full' unless spot

    spot.park!(Vehicle.new(vehicle_plate, color))
    puts "Vehicle #{spot.vehicle.plate} is parked at #{spot.spot_id}"
  end

  def unpark(vehicle_plate)
    _, spot = find_spot_by_plate(vehicle_plate)
    unless spot
      raise VehicleNotFoundError,
            "No Vehicle parked with vehicle plate #{vehicle_plate}"
    end

    vehicle = spot.vehicle
    spot.vacate!
    puts "Unpark a vehicle with vehicle plate #{vehicle_plate}, and color #{vehicle.color}"
    vehicle
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

  def vehicle_already_parked!
    existing_vehicle = vehicle_with_plate(vehicle_plate)
    raise ArgumentError, "Vehicle with #{vehicle_plate} already parked!" if existing_vehicle
  end
end

# lot = ParkingLot.instance

# floor1 = Floor.new('F1')
# floor2 = Floor.new('F2')

# floor1.add_spot('F1-S1')
# floor1.add_spot('F1-S2')

# floor2.add_spot('F2-S1')
# floor2.add_spot('F2-S2')
# floor2.add_spot('F2-S3')
# floor2.add_spot('F2-S4')

# lot.add_floor(floor1).add_floor(floor2)

# # lot.status

# lot.vehicle_with_plate('abcd')

# lot.park('MP-09-AB-0000', 'White')
# lot.park('MP-09-CD-1111', 'White')

# lot.park('MP-09-EF-2222', 'Red')
# lot.park('MP-09-GH-3333', 'Blue')
# lot.park('MP-09-IJ-4444', 'RED')
# lot.park('MP-09-KL-5555', 'grey')

# begin
#   lot.unpark('MP-09-EF-0000')
# rescue ParkingLot::VehicleNotFoundError => e
#   puts e.message
# end

# lot.unpark('MP-09-EF-2222')

# lot.park('MP-09-MN-6666', 'BLUE')

# lot.status

# lot.vehicle_with_plate('MP-09-AB-0000')

# lot.vehicles_with_color('white')

# begin
# lot.park('1234', 'white')
# rescue
