# frozen_string_literal: true

class Payment < ApplicationRecord
  PROVIDERS = %w[stripe].freeze
  STRIPE_AVAILABLE_METHODS = ['card', 'blik'].freeze
  STRIPE_STATUS_MAPPING = { 'paid' => :succeeded, 'unpaid' => :failed }.freeze

  belongs_to :order

  enum :status, { pending: 'pending', succeeded: 'succeeded', failed: 'failed', canceled: 'canceled', expired: 'expired' }, validate: true

  validates :provider, presence: true, inclusion: { in: PROVIDERS }
  validates :amount_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
