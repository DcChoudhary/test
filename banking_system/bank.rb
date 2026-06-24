# frozen_string_literal: true

##
# This class hold the properties of bank
#
class Bank
  attr_reader :id, :accounts

  class AccountAlreadyExistError < StandardError; end
  class InvalidAccountTypeError < StandardError; end

  def initialize(id)
    @id = id
    @accounts = {}
    @account_types = { saving: SavingAccount, current: CurrentAccount }
  end

  def create_account(account_id, type, balance)
    raise AccountAlreadyExistError, "Account with #{account_id} already exist" if find_account(account_id)

    klass = @account_types[type.to_sym].call
    raise InvalidAccountTypeError, 'Invalid account type' unless klass

    @accounts[account_id] = klass.new(account_id, balance)
  end

  private

  def find_account(account_id)
    accounts[account_id]
  end
end
