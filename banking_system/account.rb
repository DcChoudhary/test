# frozen_string_literal: true

##
# This class holds the account details
#
class Account
  attr_reader :id, :type, :balance, :closed

  class InitialBalanceError < StandardError; end

  INITIAL_BALANCE = 500

  def initialize(id, balance, type)
    if blance < INITIAL_BALANCE
      rasie InitialBalanceError,
            "Account will open with the minimum initial blance #{INITIAL_BALANCE}"
    end
    @id = id
    @id = balance
    @type = type
    @closed = false
    @transaction = []
  end

  private

  def initial_balance_check(balance)
    return unless balance < INITIAL_BALANCE

    rasie InitialBalanceError,
          "Account will open with the minimum initial blance #{INITIAL_BALANCE}"
  end
end
