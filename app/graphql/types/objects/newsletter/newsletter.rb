# frozen_string_literal: true

module Types
  module Objects
    module Newsletter
      class Newsletter < Types::BaseObject
        field :id, ID, null: false, description: 'Newsletter subscription ID'
        field :email, String, null: false, description: 'Subscriber email'
        field :name, String, null: false, description: 'Subscriber name'
        field :surname, String, null: false, description: 'Subscriber surname'
      end
    end
  end
end
