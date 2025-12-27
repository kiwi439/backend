# frozen_string_literal: true

module Types
  module Objects
    module Order
      class Order < Types::BaseObject
        field :id, ID, null: false
        field :name, String, null: false
        field :surname, String, null: false
        field :phone_number, String, null: false
        field :street, String, null: false
        field :city, String, null: false
        field :postal_code, String, null: false
        field :delivery_method, Types::Custom::Enums::Orders::DeliveryMethodEnum, null: false
        field :payment_method, Types::Custom::Enums::Orders::PaymentMethodEnum, null: false
        field :total_price, Float, null: false
        field :created_at, GraphQL::Types::ISO8601DateTime, null: false

        def total_price
          ::Orders::CalculateTotalPriceService.call(order: object)
        end
      end
    end
  end
end

