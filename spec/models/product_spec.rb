# frozen_string_literal: true

describe Product, type: :model do
  describe 'scopes' do
    describe '.promoted' do
      subject { described_class.promoted }

      before do
        create(:product)
        create(:product, promoted_from: Time.now + 2.days, promoted_to: Time.now + 3.days)
        create(:product, promoted_from: Time.now - 2.days, promoted_to: Time.now - 1.days)
        create_list(:product, 2, :promoted)
      end

      it 'returns only products from proper range' do
        expect(subject.count).to eq(2)
      end
    end

    describe '.from_type' do
      subject { described_class.from_type('stairway') }

      before do
        create(:product, product_category: create(:product_category, name: 'tools'))
        create(:product, product_category: create(:product_category, name: 'foundation_zone'))
        create_list(:product, 5, product_category: create(:product_category, name: 'stairway'))
      end

      it 'returns only products from proper range' do
        expect(subject.count).to eq(5)
      end
    end
  end

  subject do
    described_class.new(
      name: 'Stairway',
      price: 19.99,
      available_quantity: 10,
      vat_rate: 23,
      picture_key: 'images/products/roof_ accessories/grzebien_okapowy_z_kratka_wentylacyjna.jpeg',
      picture_bucket: 'budoman-development',
      product_category: build(:product_category)
    )
  end

  describe 'associations' do
    it { is_expected.to belong_to(:product_category) }
    it { is_expected.to have_many(:products_orders) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:picture_key) }
    it { is_expected.to validate_presence_of(:picture_bucket) }

    it { is_expected.to validate_numericality_of(:price) }
    it { is_expected.to validate_numericality_of(:available_quantity).only_integer }
    it { is_expected.to validate_numericality_of(:vat_rate).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe '#gross_price' do
    subject { product.gross_price }

    let(:product) { create(:product, price: 50.0, vat_rate: 23) }

    it 'returns gross price' do
      expect(subject).to eq(61.5)
    end
  end

  describe '#gross_price_cents' do
    subject { product.gross_price_cents }

    let(:product) { create(:product, price: 50.0, vat_rate: 23) }

    it 'returns gross price in cents' do
      expect(subject).to eq(6150)
    end
  end
end
