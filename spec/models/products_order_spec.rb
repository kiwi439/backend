# frozen_string_literal: true

describe ProductsOrder, type: :model do
  subject do
    described_class.new(
      order: build(:order),
      product: build(:product),
      product_quantity: 2
    )
  end

  describe 'validations' do
    it { is_expected.to validate_numericality_of(:product_quantity).only_integer }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product) }
  end

  describe '#total_gross_price' do
    subject { products_order.total_gross_price }

    let(:product) { create(:product, price: 50.0, vat_rate: 23) }
    let(:products_order) { create(:products_order, product:, product_quantity: 3) }

    it 'returns product quantity multiplied by product gross price' do
      expect(subject).to eq(184.5)
    end
  end

  describe '#total_gross_price_cents' do
    subject { products_order.total_gross_price_cents }

    let(:product) { create(:product, price: 50.0, vat_rate: 23) }
    let(:products_order) { create(:products_order, product:, product_quantity: 3) }

    it 'returns total gross price in cents' do
      expect(subject).to eq(18_450)
    end
  end
end
