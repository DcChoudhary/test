# frozen_string_literal: true

##
# This class hold all the transaction for the acount
#
class Transaction
  attr_reader :id, :amount, :type, :transfered_to

  TYPES = {
    deposit: 'deposit',
    withdraw: 'withdraw',
    transfere: 'transfere',
    transfere_service_fee: 'transfere service fee'
  }.freeze

  @@next_id = 0

  def initialize(amount, type, transfered_to = nil, parent_reference_id = nil)
    @id = generate_id
    @parent_reference_id = parent_reference_id
    @amount = amount
    @type = type
    @transfered_to = transfered_to
    @created_at = Time.now
  end

  private

  def generate_id
    @@next_id += 1
    format('TXN-%06d', @next_id)
  end
end
