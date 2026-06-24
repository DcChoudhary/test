# frozen_string_literal: true

require 'singleton'

##
# This class is main entry point of the system
#
class BankingSystem
  include Singleton

  def initialize
    @banks = {}
    @accounts = {}
  end

  def create_bank(id)
    rasie BankAlreadyExistError, "Bank with id #{id} is already present, please choose different id" if @banks[id]
    @banks[id] = Bank.new(id)
    puts "Bank with #{id} created succefully"
  end

  def create_account(bank_id, account_id, account_type, balance)
    bank = @banks[bank_id]
    raise BankNotFoundError, "Bank with id #{bank_id} not found" unless bank

    account = bank.create_account(account_id, account_type, balance)
    @accounts[account.id] = account
  end

  # deposit <account_id> <amount>
  def deposit(account_id, amount)
    find_account(account_id).deposit(amount)
  end

  def withdraw(account_id, amount)
    find_account(account_id).withdraw(amount)
  end

  private

  def find_account(account_id)
    account = @accounts[account_id]
    rise AccountNotFoundError, "Account not found with id #{account_id}" unless account
  end
end
