# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    order
    status { :pending }
    provider { 'stripe' }
    amount_cents { 1000 }
    provider_data { {} }
  end
end
