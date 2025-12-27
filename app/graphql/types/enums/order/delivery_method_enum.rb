# frozen_string_literal: true

module Types
  module Enums
    module Order
      class DeliveryMethodEnum < Types::BaseEnum
        value 'in_post'
        value 'dpd'
        value 'pick_up_at_the_point'
      end
    end
  end
end

