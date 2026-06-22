# frozen_string_literal: true

##
# This class calculate the fixed rate price for the parking slot
#
class DailyPricing
  DAY_PRICE = 100

  def calculate(ticket)
    (ticket.duration / 86_400).ceil * DAY_PRICE
  end
end
