# frozen_string_literal: true

module Types
  module Inputs
    module Mutation
      module User
        class RegisterAvatarInput < Types::BaseInputObject
          argument :base64, String, required: true
          argument :file_name, String, required: true
          argument :file_type, String, required: true
          argument :main, Boolean, required: true
        end
      end
    end
  end
end
