# frozen_string_literal: true

require_relative 'spot'

class Floor
  attr_reader :spots, :floor_number

  def initialize(floor_number)
    @floor_number = floor_number
    @spots = []
  end

  def add_spot(spot_id)
    @spots << Spot.new(spot_id)
  end

  def free_slot
    @spots.find { |spot| !spot.occupied? }
  end

  def find_spot_by_plate(plate)
    @spots.find { |spot| spot.occupied? && spot.vehicle_plate_match?(plate) }
  end

  def find_spot_by_color(color)
    @spots.select { |spot| spot.occupied? && spot.vehicle_color_match?(color) }
          .map { |spot| [self, spot] }
  end

  def status
    puts '-' * 50
    puts "Floor #{floor_number} has #{spots.size} spots"
    puts '-' * 50

    spots.each(&:status)
  end

  # def to_s
  #   "Floor #{floor_number} has #{spots.size} spots"
  # end
end
