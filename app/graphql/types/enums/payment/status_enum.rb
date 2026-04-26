# frozen_string_literal: true

module Types
  module Enums
    module Payment
      class StatusEnum < Types::BaseEnum
        graphql_name 'PaymentStatus'

        ::Payment.defined_enums.fetch('status').each_key { |name| value name }
      end
    end
  end
end
