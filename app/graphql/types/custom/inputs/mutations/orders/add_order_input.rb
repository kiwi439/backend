# frozen_string_literal: true

module Types
  module Custom
    module Inputs
      module Mutations
        module Orders
          class AddOrderInput < Types::BaseInputObject
            argument :name, String, required: true
            argument :surname, String, required: true
            argument :email, String, required: true
            argument :phone_number, String, required: true
            argument :street, String, required: true
            argument :city, String, required: true
            argument :postal_code, String, required: true
            argument :delivery_method, Types::Enums::Order::DeliveryMethodEnum, required: true
            argument :payment_method, Types::Enums::Order::PaymentMethodEnum, required: true
            argument :user_id, ID, required: true
            argument :products_order, [Types::Custom::Inputs::Mutations::Orders::ProductsOrderInput], required: true
          end
        end
      end
    end
  end
end
