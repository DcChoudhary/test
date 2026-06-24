# frozen_string_literal: true

##
# This class is sub class of the account class and hold the logic related to the saving account only
#
class SavingAccount < Account
  MINIMUM_BALANCE = 500

  def initialize(id, balance)
    super(id, balance, :saving)
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
