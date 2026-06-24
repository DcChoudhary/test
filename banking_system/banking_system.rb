# frozen_string_literal: true

require 'singleton'

##
# This class is main entry point of the system
#
class BankingSystem
  include Singleton

  def initialize
    @banks = {}
  end

  def create_bank(id)
    rasie BankAlreadyExistError, "Bank with id #{id} is already present, please choose different id" if @banks[id]
    @banks[id] = Bank.new(id)
    puts "Bank with #{id} created succefully"
  end

  # create_account <bank_id> <account_id> <account_type> <initial_balance>

  def create_account(bank_id, account_id, account_type, balance)
    bank = @banks[bank_id]
    raise BankNotFoundError, "Bank with id #{bank_id} not found" unless bank

    bank.create_account(account_id, account_type, balance)
  end
end
