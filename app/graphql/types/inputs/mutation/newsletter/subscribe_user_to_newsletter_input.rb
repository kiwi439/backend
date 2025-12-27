# frozen_string_literal: true

module Types
  module Inputs
    module Mutation
      module Newsletter
        class SubscribeUserToNewsletterInput < Types::BaseInputObject
          argument :email, ID, required: true
          argument :name, String, required: true
          argument :surname, String, required: true
        end
      end
    end
  end
end

