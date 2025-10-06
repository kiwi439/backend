# frozen_string_literal: true

module Types
  module Objects
    module User
      class User < Types::BaseObject
        field :id, ID, null: false
        field :email, String, null: false
        field :name, String, null: true
        field :surname, String, null: true
        field :phone_number, String, null: true
        field :street, String, null: true
        field :city, String, null: true
        field :postal_code, String, null: true
        field :saved_to_newsletter, Boolean, null: false
        field :avatars, [Types::Objects::User::Avatar], null: false

        def saved_to_newsletter
          Newsletter.find_by(email: object.email).present?
        end
      end
    end
  end
end
