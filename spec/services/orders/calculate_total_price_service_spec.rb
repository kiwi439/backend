describe Orders::CalculateTotalPriceService, type: :service do
  describe '#call' do
    subject { described_class.call(order: order) }

    let(:product1) { create(:product, price: 25.50) }
    let(:product2) { create(:product, price: 15.75) }
    let(:order) { create(:order, delivery_method: 'in_post') }

    before do
      create(:products_order, order: order, product: product1, product_quantity: 2)
      create(:products_order, order: order, product: product2, product_quantity: 3)
    end

    context 'when calculating total price with in_post delivery' do
      let(:order) { create(:order, delivery_method: 'in_post') }

      it 'returns correct total price' do
        expect(subject).to eq(109.24)
      end
    end

    context 'when calculating total price with dpd delivery' do
      let(:order) { create(:order, delivery_method: 'dpd') }

      it 'returns correct total price' do
        expect(subject).to eq(114.24)
      end
    end

    context 'when calculating total price with pick_up_at_the_point delivery' do
      let(:order) { create(:order, delivery_method: 'pick_up_at_the_point') }

      it 'returns correct total price' do
        expect(subject).to eq(98.25)
      end
    end

    context 'when order has single product' do
      before do
        order.products_orders.destroy_all
        create(:products_order, order: order, product: product1, product_quantity: 1)
      end

      it 'returns correct total price' do
        expect(subject).to eq(36.49)
      end
    end

    context 'when order has no products' do
      before { order.products_orders.destroy_all }

      it 'returns only delivery price' do
        expect(subject).to eq(10.99)
      end
    end

    context 'when prices have many decimal places' do
      let(:product1) { create(:product, price: 12.345) }
      let(:product2) { create(:product, price: 8.789) }

      before do
        order.products_orders.destroy_all
        create(:products_order, order: order, product: product1, product_quantity: 3)
        create(:products_order, order: order, product: product2, product_quantity: 2)
      end

      it 'rounds result to 2 decimal places' do
        expect(subject).to eq(65.60)
      end
    end
  end
end
