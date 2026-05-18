# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    order
    provider_name { Invoice::INFAKT_PROVIDER }
    sequence(:external_uuid) { |n| "infakt-invoice-uuid-#{n}" }
  end
end
