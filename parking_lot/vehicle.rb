# frozen_string_literal: true

class Vehicle
  attr_reader :plate, :color

  def initialize(plate, color)
    @plate = plate
    @color = color
  end
end
