# frozen_string_literal: true

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
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to have_many(:products_orders).dependent(:destroy) }
    it { is_expected.to have_many(:payments).dependent(:destroy) }
    it { is_expected.to have_one(:invoice).dependent(:destroy) }
  end

  describe '#delivery_details' do
    subject { order.delivery_details }

    context 'when delivery method is in_post' do
      let(:order) { build(:order, delivery_method: 'in_post') }

      it 'returns matching delivery details' do
        expect(subject).to eq(
          method: 'in_post',
          price: 10.99,
          vat_rate: 23,
          label: 'Dostawa: Paczkomat InPost'
        )
      end
    end

    context 'when delivery method is pick_up_at_the_point' do
      let(:order) { build(:order, delivery_method: 'pick_up_at_the_point') }

      it 'returns delivery details with zero price' do
        expect(subject.fetch(:price)).to eq(0.0)
        expect(subject.fetch(:label)).to eq('Odbiór osobisty')
      end
    end
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

  describe '#latest_payment' do
    subject { order.latest_payment }

    let(:order) { create(:order) }

    it 'returns nil when order has no payments' do
      expect(subject).to be_nil
    end

    it 'returns most recently created payment' do
      create(:payment, order: order, amount_cents: 1000, created_at: 2.days.ago)
      newer_payment = create(:payment, order: order, amount_cents: 2000, created_at: 1.day.ago)

      expect(subject).to eq(newer_payment)
    end
  end

  describe '#total_price' do
    subject { order.total_price }

    let(:order) { create(:order) }

    it 'returns 0 when order has no payments' do
      expect(subject).to eq(0)
    end

    it 'returns latest payment amount in PLN' do
      create(:payment, order: order, amount_cents: 45_913)
      expect(subject).to eq(459.13)
    end
  end
end
