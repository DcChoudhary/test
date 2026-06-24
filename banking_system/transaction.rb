# frozen_string_literal: true

##
# This class hold all the transaction for the acount
#
class Transaction
  attr_reader :id

  def initialize(id)
    @id = id
  end
end
