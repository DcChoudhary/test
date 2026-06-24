# frozen_string_literal: true

require_relative 'transaction'

##
# This class holds the account details
#
class Account
  attr_reader :id, :type, :balance, :closed

  class InitialBalanceError < ApplicationError; end
  class InsufficientBalanceError < ApplicationError; end

  INITIAL_BALANCE = 500
  CROSS_BANK_TRANSACTION_FEE_PERCENTAGE = 20

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
    balance_check(amount)

    @balance -= amount
    create_transaction(amount, Transaction::TYPES[:withdraw])
    puts "Amount #{amount} is succefully withdraw, current balance is #{balance}"
  end

  def remianing_balance(amount)
    balance - amount
  end

  def transfer_debit(amount, same_bank)
    actual_amount = amount
    amount += extra_fee(actual_amount) unless same_bank
    unless same_bank
      puts "Cross bank detected, you will be charged #{CROSS_BANK_TRANSACTION_FEE_PERCENTAGE} % extra of transfer amount"
    end
    balance_check(amount)

    @balance -= amount
    puts "Amount #{amount} is debited from account #{id}"
    transaction = create_transaction(actual_amount, Transaction::TYPES[:transfer], self)
    create_transaction(extra_fee(actual_amount), Transaction::TYPES[:transfer_service_fee], nil, transaction.id)
  end

  def transfer_credit(amount)
    @balance += amount
    create_transaction(amount, Transaction::TYPES[:transfer], nil, self)
    puts "Amount #{amount} is credited, current balance is #{balance}"
  end

  def close_account
    @closed = true
    puts "Account #{id} is succefully closed"
  end

  private

  def create_transaction(amount, type, transfer_to = nil)
    transaction = Transaction.new(amount, type, transfer_to)
    @transaction << transaction
    transaction
  end

  def extra_fee(amount)
    amount * (CROSS_BANK_TRANSACTION_FEE_PERCENTAGE / 100.0)
  end

  def blanace_check(amount)
    raise InsufficientBalanceError, 'Insufficient balance' if remianing_balance(amount).negavite?
  end

  def initial_balance_check(balance)
    return unless balance < INITIAL_BALANCE

    raise InitialBalanceError,
          "Account will open with the minimum initial blance #{INITIAL_BALANCE}"
  end
end
