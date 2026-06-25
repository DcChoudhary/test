# frozen_string_literal: true

require_relative 'transaction'

##
# This class holds the account details
#
class Account
  attr_reader :id, :type, :balance, :closed, :transactions

  class InitialBalanceError < ApplicationError; end
  class InsufficientBalanceError < ApplicationError; end
  class NegativeAmountError < ApplicationError; end

  INITIAL_BALANCE = 500
  CROSS_BANK_TRANSACTION_FEE_PERCENTAGE = 20

  def initialize(id, balance, type)
    initial_balance_check(balance)
    @id = id
    @balance = balance
    @type = type
    @closed = false
    @transactions = []
  end

  def deposit(amount)
    amount_check(amount)
    @balance += amount
    create_transaction(amount, Transaction::TYPES[:deposit])
    puts "Amount #{amount} is successfully deposit, current balance is #{balance}"
  end

  def withdraw(amount)
    amount_check(amount)
    balance_check(amount)

    @balance -= amount
    create_transaction(amount, Transaction::TYPES[:withdraw])
    puts "Amount #{amount} is successfully withdraw, current balance is #{balance}"
  end

  def remaining_balance(amount)
    balance - amount
  end

  def transfer_debit(amount, same_bank)
    amount_check(amount)
    actual_amount = amount
    amount += extra_fee(actual_amount) unless same_bank
    unless same_bank
      puts "Cross bank detected, you will be charged #{CROSS_BANK_TRANSACTION_FEE_PERCENTAGE} % extra of transfer amount"
    end
    balance_check(amount)

    @balance -= amount
    puts "Amount #{amount} is debited from account #{id}"
    transaction = create_transaction(actual_amount, Transaction::TYPES[:transfer], self)
    create_transaction(extra_fee(actual_amount), Transaction::TYPES[:transfer_service_fee], nil, transaction.id, nil)
  end

  def transfer_credit(amount)
    @balance += amount
    create_transaction(amount, Transaction::TYPES[:transfer], nil, self, nil)
    puts "Amount #{amount} is credited, current balance is #{balance}"
  end

  def close_account
    @closed = true
    puts "Account #{id} is successfully closed"
  end

  def create_transaction(amount, type, transfer_to = nil, transfer_from = nil, parent_reference_id = nil)
    transaction = Transaction.new(amount, type, transfer_to, transfer_from, parent_reference_id)
    @transactions << transaction
    transaction
  end

  private

  def extra_fee(amount)
    amount * (CROSS_BANK_TRANSACTION_FEE_PERCENTAGE / 100.0)
  end

  def balance_check(amount)
    raise InsufficientBalanceError, 'Insufficient balance' if remaining_balance(amount).negative?
  end

  def amount_check(amount)
    raise NegativeAmountError, 'Amount should be grater than 0' if amount <= 0
  end

  def initial_balance_check(balance)
    return unless balance < INITIAL_BALANCE

    raise InitialBalanceError,
          "Account will open with the minimum initial balance #{INITIAL_BALANCE}"
  end
end
