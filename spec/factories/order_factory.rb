FactoryBot.define do
	factory :order do
		name { 'John' }
		surname { 'Doe' }
		phone_number { '123456789' }
		street { 'Main street' }
		city { 'London' }
		postal_code { '34-300' }
		delivery_method { Order::DELIVERIES_DETAILS.dig(0, :method) }
		email { 'john.doe123@gmail.com' }

		user 
	end
end
