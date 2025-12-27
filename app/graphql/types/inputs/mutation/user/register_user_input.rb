# frozen_string_literal: true

module Types
  module Inputs
    module Mutation
      module User
        class RegisterUserInput < Types::BaseInputObject
          argument :email, String, required: true
          argument :password, String, required: true
          argument :avatars, [RegisterAvatarInput], required: true
        end
      end
    end
  end
end

