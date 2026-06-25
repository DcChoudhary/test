# frozen_string_literal: true

require 'singleton'
require_relative 'bank'

##
# This class is main entry point of the system
#
class BankingSystem
  include Singleton

  class AccountCloseError < ApplicationError; end
  class BankAlreadyExistError < ApplicationError; end
  class BankNotFoundError < ApplicationError; end
  class AccountNotFoundError < ApplicationError; end
  class TransferNotAllowed < ApplicationError; end

  def initialize
    @banks = {}
    @accounts = {}
  end

  def create_bank(id)
    raise BankAlreadyExistError, "Bank with id #{id} is already present, please choose different id" if @banks[id]

    @banks[id] = Bank.new(id)
    puts "Bank with #{id} created successfully"
  end

  def create_account(bank_id, account_id, account_type, balance)
    bank = @banks[bank_id]
    raise BankNotFoundError, "Bank with id #{bank_id} not found" unless bank

    account = bank.create_account(account_id, account_type, balance.to_f)
    @accounts[account.id] = account
    puts "Account #{account.id} created successfully in bank #{bank.id}"
  end

  # deposit <account_id> <amount>
  def deposit(account_id, amount)
    find_account(account_id).deposit(amount.to_f)
  end

  def withdraw(account_id, amount)
    find_account(account_id).withdraw(amount.to_f)
  end

  def transfer(from_account_id, to_account_id, amount)
    from_account = find_account(from_account_id)
    to_account = find_account(to_account_id)
    raise TransferNotAllowed, 'Transfer to same account not allowed' if from_account == to_account

    from_account.transfer_debit(amount.to_f, same_bank(from_account, to_account))
    to_account.transfer_credit(amount.to_f)
  end

  def balance(account_id)
    balance = find_account(account_id).balance
    puts "Account #{account_id}, current balance is #{balance}"
  end

  def statement(account_id)
    find_account(account_id).transactions.each do |transaction|
      puts transaction
    end
  end

  def close_account(account_id)
    find_account(account_id).close_account
  end

  private

  def same_bank(from_account, to_account)
    @banks.each_value do |bank|
      accounts = bank.accounts

      return true if accounts.find { |id, _| id == from_account.id } &&
                     accounts.find { |id, _| id == to_account.id }
    end
    false
  end

  def find_account(account_id)
    account = @accounts[account_id]
    raise AccountNotFoundError, "Account not found with id #{account_id}" unless account
    raise AccountCloseError, 'Account is closed' if account.closed

    account
  end
end
