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

  def transfer(from_account_id, to_account_id, amount)
    from_account = find_account(from_account_id)
    to_account = find_account(to_account_id)

    from_account.transfere_debit(amount, same_bank)
    to_account.transfere_credit(amount)
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

  private

  def same_bank(from_account, to_account)
    @banks.select do |_, bank|
      [from_account, to_account].include?(bank.account)
    end.size == 1
  end

  def find_account(account_id)
    account = @accounts[account_id]
    rise AccountNotFoundError, "Account not found with id #{account_id}" unless account
  end
end
