# frozen_string_literal: true

module Types
  module Inputs
    module Query
      class OrdersInput < Types::BaseInputObject
        argument :pagination, PaginationInput, required: true
        argument :user_id, ID, required: false
      end
    end
  end
end
