FactoryBot.define do
  factory :product do
    name { 'Powłoka przeciwwilgociowa' }
    price { 225.99 }
    vat_rate { 23 }
    available_quantity { 24 }
    picture_key { 'path_to_source_on_storage' }
    picture_bucket { Rails.application.config.x.aws_bucket }
    promoted_from { nil }
    promoted_to { nil }

    product_category

    trait :promoted do
      promoted_from { Time.now - 2.days }
      promoted_to { Time.now + 2.days }
    end
  end
end
