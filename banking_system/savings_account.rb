# frozen_string_literal: true

require_relative 'account'

##
# This class is sub class of the account class and hold the logic related to the savings account only
#
class SavingsAccount < Account
  class MinimumBalanceError < ApplicationError; end

  MINIMUM_BALANCE = 500

  def initialize(id, balance)
    super(id, balance, :savings)
  end

  def withdraw(amount)
    minimum_balance_check(amount)
    super(amount)
  end

  private

  def minimum_balance_check(amount)
    return if remianing_balance(amount) >= MINIMUM_BALANCE

    raise MinimumBalanceError,
          "After the current transaction the balance go low then the minimum balance limit of #{MINIMUM_BALANCE},
           you can only withdraw upto #{balance - MINIMUM_BALANCE}"
  end
end
