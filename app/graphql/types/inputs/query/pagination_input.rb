# frozen_string_literal: true

module Types
  module Inputs
    module Query
      class PaginationInput < Types::BaseInputObject
        argument :page, Integer, required: true
        argument :quantity_per_page, Integer, required: true
      end
    end
  end
end

