# frozen_string_literal: true

module Types
  module Objects
    module Payment
      class Payment < Types::BaseObject
        field :id, ID, null: false
        field :amount_cents, Integer, null: false
        field :provider, String, null: false
        field :status, Types::Enums::Payment::StatusEnum, null: false
      end
    end
  end
end
