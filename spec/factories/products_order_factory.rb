FactoryBot.define do
  factory :products_order do
    association :order
    association :product
    product_quantity { 1 }
  end
end
