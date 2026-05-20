# frozen_string_literal: true

module Types
  module Objects
    module Invoice
      class Pdf < Types::BaseObject
        description 'Invoice PDF from Infakt (Base64-encoded binary)'

        field :pdf_base64, String, null: false, description: 'PDF document encoded as Base64'
      end
    end
  end
end
