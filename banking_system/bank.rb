# frozen_string_literal: true

require_relative 'saving_account'
require_relative 'current_account'

##
# This class hold the properties of bank
#
class Bank
  attr_reader :id, :accounts

  class AccountAlreadyExistError < ApplicationError; end
  class InvalidAccountTypeError < ApplicationError; end

  def initialize(id)
    @id = id
    @accounts = {}
  end

  def create_account(account_id, type, balance)
    raise AccountAlreadyExistError, "Account with #{account_id} already exist" if find_account(account_id)

    klass = Account::ACCOUNT_TYPES[type.to_sym]
    raise InvalidAccountTypeError, 'Invalid account type' unless klass

    @accounts[account_id] = klass.new(account_id, balance)
  end

  def find_account(account_id)
    accounts[account_id]
  end
end
