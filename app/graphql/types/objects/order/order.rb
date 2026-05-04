# frozen_string_literal: true

module Types
  module Objects
    module Order
      class Order < Types::BaseObject
        field :city, String, null: false, description: 'Delivery city'
        field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'Order creation timestamp'
        field :delivery_method, Types::Enums::Order::DeliveryMethodEnum, null: false, description: 'Delivery method'
        field :id, ID, null: false, description: 'Order ID'
        field :latest_payment, Types::Objects::Payment::Payment, null: true, description: 'Most recent payment attempt'
        field :name, String, null: false, description: 'Customer name'
        field :paid, Boolean, null: false, method: :paid?, description: 'Whether the order has a succeeded payment'
        field :payment_method, Types::Enums::Order::PaymentMethodEnum, null: false, description: 'Payment method'
        field :phone_number, String, null: false, description: 'Customer phone number'
        field :postal_code, String, null: false, description: 'Delivery postal code'
        field :street, String, null: false, description: 'Delivery street address'
        field :successful_payment, Types::Objects::Payment::Payment, null: true, description: 'Succeeded payment record if any'
        field :surname, String, null: false, description: 'Customer surname'
        field :total_price, Float, null: false, description: 'Total amount based on latest payment when available'
      end
    end
  end
end
