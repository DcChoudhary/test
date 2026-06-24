# frozen_string_literal: true

require 'logger'
require_relative 'application_error'
require_relative 'banking_system'

##
# This class convert the command into the method calls
#
class CommandProcessor
  class InvalidCommand < ApplicationError; end

  ALLOWED_COMMAND = %w[create_bank create_account deposit withdraw tranfer balance statment close_account].freeze

  def initialize
    @bank_sys = BankingSystem.instance
    @logger = Logger.new($stdout)
  end

  def process(command, args)
    raise InvalidCommand, 'Invalid command' unless ALLOWED_COMMAND.include?(command)

    send(command.to_sym, args)
  rescue ApplicationError => e
    puts "ERROR --> #{e.message}"
  end

  private

  def create_bank(args)
    @bank_sys.create_bank(*args)
  end

  def create_account(args)
    @bank_sys.create_account(*args)
  end

  def deposit(args)
    @bank_sys.deposit(*args)
  end

  def withdraw(args)
    @bank_sys.withdraw(*args)
  end

  def tranfer(args)
    @bank_sys.tranfer(*args)
  end

  def balance(args)
    @bank_sys.balance(*args)
  end

  def statment(args)
    @bank.statment(*args)
  end

  def close(args)
    @bank_sys.close(*args)
  end
end
