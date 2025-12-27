# frozen_string_literal: true

module Types
  module Inputs
    module Mutation
      module User
        class LoginUserInput < Types::BaseInputObject
          argument :email, String, required: true
          argument :password, String, required: true
        end
      end
    end
  end
end

