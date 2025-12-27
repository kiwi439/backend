# frozen_string_literal: true

module Types
  module Enums
    module Order
      class PaymentMethodEnum < Types::BaseEnum
        value 'cash_payment'
        value 'traditional_transfer'
      end
    end
  end
end
