# frozen_string_literal: true

module Types
  module Inputs
    module Mutation
      module User
        class UpdateUserInput < Types::BaseInputObject
          argument :avatars, [UpdateAvatarInput], required: false
          argument :city, String, required: false
          argument :name, String, required: false
          argument :password, String, required: false
          argument :phone_number, String, required: false
          argument :postal_code, String, required: false
          argument :street, String, required: false
          argument :surname, String, required: false
          argument :user_id, ID, required: true
        end
      end
    end
  end
end
