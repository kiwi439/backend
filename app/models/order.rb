# frozen_string_literal: true

class Order < ApplicationRecord
  DELIVERIES_DETAILS = [
    { method: 'in_post', price: 10.99, label: 'Dostawa: Paczkomat InPost' },
    { method: 'dpd', price: 15.99, label: 'Dostawa: DPD' },
    { method: 'pick_up_at_the_point', price: 0.0, label: 'Odbiór osobisty' }
  ].freeze

  ALLOWED_PAYMENT_METHOD = %w[stripe_payment].freeze

  belongs_to :user
  has_many :products_orders, dependent: :destroy
  has_many :payments, dependent: :destroy

  validates :name, presence: true
  validates :surname, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :email, presence: true, format: { with: Constants::EMAIL_REGEX }
  validates :postal_code, presence: true, format: { with: Constants::POSTAL_CODE_REGEX }
  validates :phone_number, presence: true, format: { with: Constants::PHONE_NUMBER_REGEX }
  validates :delivery_method, inclusion: { in: DELIVERIES_DETAILS.pluck(:method) }
  validates :payment_method, inclusion: { in: ALLOWED_PAYMENT_METHOD }

  def paid?
    payments.succeeded.any?
  end

  def successful_payment
    payments.succeeded.order(created_at: :desc).first
  end
end
