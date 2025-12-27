# frozen_string_literal: true

module Types
  module Inputs
    module Query
      class OrdersInput < Types::BaseInputObject
        argument :user_id, ID, required: false
        argument :pagination, PaginationInput, required: true
      end
    end
  end
end

