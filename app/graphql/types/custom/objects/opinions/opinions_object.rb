# frozen_string_literal: true

module Types
  module Custom
    module Objects
      module Opinions
        class OpinionsObject < Types::BaseObject
          field :opinions, [Types::Custom::Objects::Opinions::OpinionObject], null: false
          field :total_count, Integer, null: false
        end
      end
    end
  end
end

