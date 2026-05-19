describe Order, type: :model do
  subject { build(:order) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:surname) }
    it { is_expected.to validate_presence_of(:street) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:postal_code) }
    it { is_expected.to validate_presence_of(:phone_number) }

    it { is_expected.to validate_inclusion_of(:delivery_method).in_array(Order::DELIVERIES_DETAILS.pluck(:method)) }

    it { is_expected.to allow_value('john.doe@example.com').for(:email) }
    it { is_expected.not_to allow_value('test').for(:email) }

    it { is_expected.to allow_value('34-300').for(:postal_code) }
    it { is_expected.not_to allow_value('34300').for(:postal_code) }
    it { is_expected.not_to allow_value('ab-cde').for(:postal_code) }

    it { is_expected.to allow_value('123456789').for(:phone_number) }
    it { is_expected.not_to allow_value('abc').for(:phone_number) }
    it { is_expected.not_to allow_value('123-456-789').for(:phone_number) }
    it { is_expected.not_to allow_value('12345678').for(:phone_number) }
    it { is_expected.not_to allow_value('1234567890').for(:phone_number) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:products_orders).dependent(:destroy) }
    it { is_expected.to have_many(:payments).dependent(:destroy) }
  end

  describe '#paid?' do
    subject { order.paid? }

    let(:order) { create(:order) }

    it 'returns true when order has succeeded payment' do
      create(:payment, order: order, status: :succeeded)
      expect(subject).to be(true)
    end

    it 'returns false when order has no succeeded payments' do
      create(:payment, order: order, status: :pending)
      create(:payment, order: order, status: :failed)

      expect(subject).to be(false)
    end
  end
end
