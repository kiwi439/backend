# frozen_string_literal: true

module Types
  module Objects
    module Product
      class Product < Types::BaseObject
        field :id, ID, null: false
        field :name, String, null: false
        field :price, Float, null: false
        field :available_quantity, Integer, null: false
        field :picture_key, String, null: false
        field :picture_bucket, String, null: false
      end
    end
  end
end

