FactoryBot.define do
  factory :opinion do
    association :user
    content { 'Great product, highly recommended!' }
    mark { 5 }
  end
end
