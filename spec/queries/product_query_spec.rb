describe ProductQuery do
  describe '#call' do
    subject { described_class.new(params).call }

    let(:category1) { create(:product_category, name: 'stairway') }
    let(:category2) { create(:product_category, name: 'doors') }
    let(:product1) { create(:product, product_category: category1, price: 100.0, available_quantity: 5, promoted_from: nil, promoted_to: nil) }
    let(:product2) { create(:product, product_category: category2, price: 200.0, available_quantity: 0, promoted_from: nil, promoted_to: nil) }
    let(:product3) { create(:product, product_category: category1, price: 150.0, available_quantity: 3, promoted_from: 1.day.ago, promoted_to: 1.day.from_now) }
    let(:product4) { create(:product, product_category: category2, price: 250.0, available_quantity: 2, promoted_from: nil, promoted_to: nil) }

    before do
      product1.update!(created_at: 4.days.ago)
      product2.update!(created_at: 3.days.ago)
      product3.update!(created_at: 2.days.ago)
      product4.update!(created_at: 1.day.ago)
    end

    context 'when no params are provided' do
      let(:params) { { input: {} } }

      it 'returns all available products sorted by price' do
        result = subject
        expect(result[:products].to_a).to eq([product1, product3, product4])
        expect(result[:quantity]).to eq(3)
      end
    end

    context 'when filtering by promoted products' do
      let(:params) { { input: { promoted: true } } }

      it 'returns only promoted and available products sorted by price' do
        result = subject
        expect(result[:products].to_a).to eq([product3])
        expect(result[:quantity]).to eq(1)
      end
    end

    context 'when filtering by type' do
      let(:params) { { input: { type: 'Stairway' } } }

      it 'returns only products from specified category sorted by price' do
        result = subject
        expect(result[:products].to_a).to eq([product1, product3])
        expect(result[:quantity]).to eq(2)
      end
    end

    context 'when combining promoted and type filters' do
      let(:params) { { input: { promoted: true, type: 'Stairway' } } }

      it 'returns only promoted products from specified category sorted by price' do
        result = subject
        expect(result[:products].to_a).to eq([product3])
        expect(result[:quantity]).to eq(1)
      end
    end

    context 'when pagination params are provided' do
      let(:params) do
        {
          input: {
            pagination: {
              page: 0,
              quantity_per_page: 2
            }
          }
        }
      end

      it 'returns paginated products sorted by price' do
        result = subject
        expect(result[:products].to_a).to eq([product1, product3])
        expect(result[:quantity]).to eq(3)
      end
    end

    context 'when requesting second page' do
      let(:params) do
        {
          input: {
            pagination: {
              page: 1,
              quantity_per_page: 2
            }
          }
        }
      end

      it 'returns products from second page' do
        result = subject
        expect(result[:products].to_a).to eq([product4])
        expect(result[:quantity]).to eq(3)
      end
    end

    context 'when combining filters and pagination' do
      let(:params) do
        {
          input: {
            type: 'Stairway',
            pagination: {
              page: 0,
              quantity_per_page: 1
            }
          }
        }
      end

      it 'returns paginated products with filters applied' do
        result = subject
        expect(result[:products].to_a).to eq([product1])
        expect(result[:quantity]).to eq(2)
      end
    end

    context 'when requesting page beyond available data' do
      let(:params) do
        {
          input: {
            pagination: {
              page: 5,
              quantity_per_page: 2
            }
          }
        }
      end

      it 'returns empty products array with correct quantity' do
        result = subject
        expect(result[:products]).to be_empty
        expect(result[:quantity]).to eq(3)
      end
    end

    context 'when quantity_per_page is larger than total products' do
      let(:params) do
        {
          input: {
            pagination: {
              page: 0,
              quantity_per_page: 10
            }
          }
        }
      end

      it 'returns all products' do
        result = subject
        expect(result[:products].to_a).to eq([product1, product3, product4])
        expect(result[:quantity]).to eq(3)
      end
    end

    context 'when promoted filter is false' do
      let(:params) { { input: { promoted: false } } }

      it 'returns all available products (same as no filter)' do
        result = subject
        expect(result[:products].to_a).to eq([product1, product3, product4])
        expect(result[:quantity]).to eq(3)
      end
    end
  end
end
