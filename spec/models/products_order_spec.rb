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
end
