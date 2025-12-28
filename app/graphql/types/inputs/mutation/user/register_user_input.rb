# frozen_string_literal: true

module Types
  module Inputs
    module Mutation
      module User
        class RegisterUserInput < Types::BaseInputObject
          argument :avatars, [RegisterAvatarInput], required: true
          argument :email, String, required: true
          argument :password, String, required: true
        end
      end
    end
  end
end
