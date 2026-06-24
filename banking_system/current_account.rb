# frozen_string_literal: true

require_relative 'account'

##
# This is a sub class of the account class and hold the logic for current account only
#
class CurrentAccount < Account
  DAILY_WITHDRAW_LIMIT = 50_000

  class DailyWithdrawLimitError < ApplicationError; end

  def initialize(id, balance)
    super(id, balance, :current)
  end

  def withdraw(amount)
    withdraw_limit_check(amount)
    super(amount)
  end

  private

  def withdraw_limit_check(amount)
    if today_withdraw_amount >= DAILY_WITHDRAW_LIMIT
      raise DailyWithdrawLimitError,
            "You have reached you daily limit of #{DAILY_WITHDRAW_LIMIT}"
    end

    raise DailyWithdrawLimitError, "You can only withdraw #{daily_remeaning_limit}" if daily_remeaning_limit < amount
  end

  def daily_remeaning_limit
    DAILY_WITHDRAW_LIMIT - today_withdraw_amount
  end

  def today_withdraw_amount
    @today_withdraw_amount ||= transactions.select do |tran|
      tran.created_at <= end_of_today && tran.created_at <= begin_of_today
    end.sum(&:amount)
  end

  def begin_of_today
    now = Time.now
    Time.new(now.year, now.month, now.day, 0o0, 0o0, 0o0)
  end

  def end_of_today
    now = Time.now
    Time.new(now.year, now.month, now.day, 23, 59, 59)
  end
end
