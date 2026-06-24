# frozen_string_literal: true

##
# This is a sub class of the account class and hold the logic for current account only
#
class CurrentAccount < Account
  def initialize(id, balance)
    super(id, balance, :current)
  end
end
