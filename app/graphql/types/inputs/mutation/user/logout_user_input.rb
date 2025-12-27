# frozen_string_literal: true

module Types
  module Inputs
    module Mutation
      module User
        class LogoutUserInput < Types::BaseInputObject
          argument :id, ID, required: true
        end
      end
    end
  end
end

