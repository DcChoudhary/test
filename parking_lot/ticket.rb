# frozen_string_literal: true

require 'securerandom'

##
# This class only hold the infoemation about the ticket
#
class Ticket
  include SecureRandom

  attr_reader :id, :entry_time, :vehicle, :spot, :exit_time

  def initialize(vehicle, spot, entry_time)
    @id = "TKT-#{spot.spot_id}-#{SecureRandom.hex(4)}"
    @vehicle = vehicle
    @spot = spot
    @entry_time = entry_time
    @exit_time = nil
  end

  def close!
    raise 'Already closed' unless exit_time

    @exit_time = Time.now
    spot.vacate!
  end
end
