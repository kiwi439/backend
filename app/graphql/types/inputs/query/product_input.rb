# frozen_string_literal: true

module Types
  module Inputs
    module Query
      class ProductInput < Types::BaseInputObject
        argument :promoted, Boolean, required: false
        argument :type, String, required: false
        argument :pagination, PaginationInput, required: true
      end
    end
  end
end

