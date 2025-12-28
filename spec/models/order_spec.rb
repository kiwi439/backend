describe Order, type: :model do
  subject do
    described_class.new(
      name: 'John',
      surname: 'Doe',
      phone_number: '123456789',
      street: 'Main street',
      city: 'London',
      postal_code: '34-300',
      delivery_method: Order::DELIVERIES_DETAILS.dig(0, :method),
      payment_method: Order::ALLOWED_PAYMENT_METHOD[0],
      email: 'john.doe@example.com',
      user: build(:user)
    )
  end

  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:delivery_method).in_array(Order::DELIVERIES_DETAILS.pluck(:method)) }
    it { is_expected.to validate_inclusion_of(:payment_method).in_array(Order::ALLOWED_PAYMENT_METHOD) }

    it { is_expected.to allow_value('123456789').for(:phone_number) }
    it { is_expected.not_to allow_value('abc').for(:phone_number) }
    it { is_expected.not_to allow_value('123-456-789').for(:phone_number) }
    it { is_expected.not_to allow_value('12345678').for(:phone_number) }
    it { is_expected.not_to allow_value('1234567890').for(:phone_number) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:products_orders).dependent(:destroy) }
  end
end


