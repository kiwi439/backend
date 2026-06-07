# frozen_string_literal: true

module Types
  module Inputs
    module Mutation
      module Order
        class AddOrderInput < Types::BaseInputObject
          argument :city, String, required: true
          argument :delivery_method, Types::Enums::Order::DeliveryMethodEnum, required: true
          argument :email, String, required: true
          argument :name, String, required: true
          argument :phone_number, String, required: true
          argument :postal_code, String, required: true
          argument :products_order, [ProductsOrderInput], required: true
          argument :street, String, required: true
          argument :surname, String, required: true
          argument :user_id, ID, required: false
        end
      end
    end
  end
end
