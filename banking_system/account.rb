# frozen_string_literal: true

##
# This class holds the account details
#
class Account
  attr_reader :id, :type, :balance, :closed

  class InitialBalanceError < StandardError; end

  INITIAL_BALANCE = 500

  def initialize(id, balance, type)
    initial_balance_check(balance)
    @id = id
    @balance = balance
    @type = type
    @closed = false
    @transaction = []
  end

  def deposit(amount)
    @balance += amount
    create_transaction(amount, Transaction::TYPES[:deposit])
    puts "Amount #{amount} is succefully deposit, current balance is #{balance}"
  end

  private

  def create_transaction(amount, type)
    @transaction << Transaction.new(amount, type)
  end

  def initial_balance_check(balance)
    return unless balance < INITIAL_BALANCE

    rasie InitialBalanceError,
          "Account will open with the minimum initial blance #{INITIAL_BALANCE}"
  end
end
