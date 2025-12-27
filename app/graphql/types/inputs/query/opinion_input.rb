# frozen_string_literal: true

module Types
  module Inputs
    module Query
      class OpinionInput < Types::BaseInputObject
        graphql_name 'OpinionFilterInput'
        argument :pagination, PaginationInput, required: false
      end
    end
  end
end
