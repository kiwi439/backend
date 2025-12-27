# frozen_string_literal: true

module Types
  module Inputs
    module Mutation
      module User
        class UpdateAvatarInput < Types::BaseInputObject
          argument :main, Boolean, required: true
          argument :storage_path, String, required: true
        end
      end
    end
  end
end
