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

  def transfere_debit(amount, same_bank)
    actual_amount = amount
    amount += extra_fee(actual_amount) unless same_bank
    unless same_bank
      puts "Cross bank detected, you will be charged #{CROSS_BANK_TRANSACTION_FEE_PERCENTAGE} % extra of transfere amount"
    end
    balance_check(amount)

    @balance -= amount
    puts "Amount #{amount} is debited from account #{id}"
    transaction = create_transaction(actual_amount, Transaction::TYPES[:transfer], self)
    create_transaction(extra_fee(actual_amount), Transaction::TYPES[:transfer_fee], nil, transaction)
  end

  def transfere_credit(amount)
    @balance += amount
    create_transaction(amount, Transaction::TYPES[:transfer], nil, self)
    puts "Amount #{amount} is credited, current balance is #{balance}"
  end

  private

  def create_transaction(amount, type, transfere_to = nil)
    transaction = Transaction.new(amount, type, transfere_to)
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

    rasie InitialBalanceError,
          "Account will open with the minimum initial blance #{INITIAL_BALANCE}"
  end
end
