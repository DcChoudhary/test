# frozen_string_literal: true

##
# This class hold all the transaction for the acount
#
class Transaction
  attr_reader :id, :amount, :type, :transfered_to, :created_at, :transfered_from

  TYPES = {
    deposit: 'deposit',
    withdraw: 'withdraw',
    transfere: 'transfere',
    transfere_service_fee: 'transfere service fee'
  }.freeze

  @@next_id = 0

  def initialize(amount, type, transfered_to = nil, transfered_from = nil, parent_reference_id = nil)
    @id = generate_id
    @parent_reference_id = parent_reference_id
    @amount = amount
    @type = type
    @transfered_to = transfered_to
    @transfered_from = transfered_from
    @created_at = Time.now
  end

  def to_s
    message = case type
              when 'deposit'
                "Amount #{amount} deposited at #{created_at}"
              when 'withdraw'
                "Amount #{amount} withdraw at #{created_at}"
              when 'transfere'
                transfere_message
              when 'transfere service fee'
                "Amount #{amount} is charged for cross bank transfere from transaction id #{parent_reference_id} at #{created_at}"
              end
    "Transaction-- #{message}"
  end

  private

  def transfere_message
    if transfered_to.present?
      "Amount #{amount} is transfered to #{transfered_to.id} account at #{created_at}"
    else
      "Amount #{amount} is transfered from #{transfered_from.id} account at #{created_at}"
    end
  end

  def generate_id
    @@next_id += 1
    format('TXN-%06d', @next_id)
  end
end
