# frozen_string_literal: true

class Order < ApplicationRecord
  DELIVERIES_DETAILS = [
    { method: 'in_post', price: 10.99, vat_rate: 23, label: 'Dostawa: Paczkomat InPost' },
    { method: 'dpd', price: 15.99, vat_rate: 23, label: 'Dostawa: DPD' },
    { method: 'pick_up_at_the_point', price: 0.0, vat_rate: 23, label: 'Odbiór osobisty' }
  ].freeze

  belongs_to :user
  has_many :products_orders, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_one :invoice, dependent: :destroy

  validates :name, presence: true
  validates :surname, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :email, presence: true, format: { with: Constants::EMAIL_REGEX }
  validates :postal_code, presence: true, format: { with: Constants::POSTAL_CODE_REGEX }
  validates :phone_number, presence: true, format: { with: Constants::PHONE_NUMBER_REGEX }
  validates :delivery_method, inclusion: { in: DELIVERIES_DETAILS.pluck(:method) }

  def delivery_details
    DELIVERIES_DETAILS.find { |d| d.fetch(:method) == delivery_method }
  end

  def paid?
    payments.succeeded.any?
  end

  def latest_payment
    payments.order(created_at: :desc).first
  end

  def total_price
    (latest_payment&.amount_cents.to_i / Constants::PLN_TO_CENTS_MULTIPLIER)
  end
end
