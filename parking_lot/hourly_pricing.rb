# frozen_string_literal: true

##
# Responsible to calulate the houly pricing of the parking spot
#
class HourlyPricing
  PER_HOUR_RATE = 10

  def calculate(ticket)
    (ticket.duration / 3600).ceil * PER_HOUR_RATE
  end
end
