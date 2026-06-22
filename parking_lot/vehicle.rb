# frozen_string_literal: true

##
# This class holds the information about the Vehicle
#
class Vehicle
  attr_reader :plate, :color

  def initialize(plate, color)
    @plate = plate
    @color = color
  end
end
