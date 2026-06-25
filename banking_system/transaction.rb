# frozen_string_literal: true

##
# This class hold all the transaction for the account
#
class Transaction
  attr_reader :id, :amount, :type, :transferred_to, :created_at, :transferred_from

  TYPES = {
    deposit: 'deposit',
    withdraw: 'withdraw',
    transfer: 'transfer',
    transfer_service_fee: 'transfer service fee'
  }.freeze

  @@next_id = 0

  def initialize(amount, type, transferred_to = nil, transferred_from = nil, parent_reference_id = nil)
    @id = generate_id
    @parent_reference_id = parent_reference_id
    @amount = amount
    @type = type
    @transferred_to = transferred_to
    @transferred_from = transferred_from
    @created_at = Time.now
  end

  def to_s
    message = case type
              when 'deposit'
                "Amount #{amount} deposited at #{created_at}"
              when 'withdraw'
                "Amount #{amount} withdraw at #{created_at}"
              when 'transfer'
                transfer_message
              when 'transfer service fee'
                "Amount #{amount} is charged for cross bank transfer from transaction id #{parent_reference_id} at #{created_at}"
              end
    "Transaction-- #{message}"
  end

  private

  def transfer_message
    if transferred_to.present?
      "Amount #{amount} is transferred to #{transferred_to.id} account at #{created_at}"
    else
      "Amount #{amount} is transferred from #{transferred_from.id} account at #{created_at}"
    end
  end

  def generate_id
    @@next_id += 1
    format('TXN-%06d', @@next_id)
  end
end
