# frozen_string_literal: true

class Spot
  attr_reader :vehicle, :spot_id

  def initialize(spot_id)
    @spot_id = spot_id
    @vehicle = nil
  end

  def occupied?
    !vehicle.nil?
  end

  def park!(vehicle)
    @vehicle = vehicle
  end

  def vacate!
    @vehicle = nil
  end

  def vehicle_plate_match?(plate)
    occupied? && vehicle.plate == plate
  end

  def vehicle_color_match?(color)
    occupied? && vehicle.color.match?(/#{color}/i)
  end

  def status
    if occupied?
      puts "spot #{spot_id} occupied by vehicle #{vehicle.plate}"
    else
      puts "Spot #{spot_id} is available"
    end
  end
end
