# frozen_string_literal: true

module Types
  module Objects
    class Product < Types::BaseObject
      field :available_quantity, Integer, null: false, description: 'Available product quantity'
      field :id, ID, null: false, description: 'Product ID'
      field :name, String, null: false, description: 'Product name'
      field :picture_bucket, String, null: false, description: 'S3 bucket name for product picture'
      field :picture_key, String, null: false, description: 'S3 key for product picture'
      field :price, Float, null: false, description: 'Product price'
    end
  end
end
