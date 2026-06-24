# frozen_string_literal: true

##
# This class holds the account details
#
class Account
  attr_reader :id, :type, :balance, :closed

  class InitialBalanceError < StandardError; end
  class InsufficientBalanceError < StandardError; end

  ACCOUNT_TYPES = {
    saving: SavingAccount,
    current: CurrentAccount
  }.freeze

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

  def withdraw(amount)
    raise InsufficientBalanceError, 'Insufficient balance' if remianing_balance(amount).negavite?

    @balance -= amount
    create_transaction(amount, Transaction::TYPES[:withdraw])
    puts "Amount #{amount} is succefully withdraw, current balance is #{balance}"
  end

  def remianing_balance(amount)
    balance - amount
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
