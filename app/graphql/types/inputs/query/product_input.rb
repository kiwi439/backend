# frozen_string_literal: true

module Types
  module Inputs
    module Query
      class ProductInput < Types::BaseInputObject
        argument :pagination, PaginationInput, required: true
        argument :promoted, Boolean, required: false
        argument :type, String, required: false
      end
    end
  end
end
