# frozen_string_literal: true

describe Payments::Stripe::CreateCheckoutSessionService, type: :service do
  describe '#call' do
    subject { described_class.call(order: order) }

    let(:order) { create(:order, delivery_method: delivery_method) }
    let(:delivery_method) { 'in_post' }
    let(:product_1) { create(:product, name: 'Grunt', price: 174.99) }
    let(:product_2) { create(:product, name: 'Klej', price: 12.3) }
    let(:checkout_session) { double('Stripe::Checkout::Session') }

    before do
      create(:products_order, order: order, product: product_1, product_quantity: 2)
      create(:products_order, order: order, product: product_2, product_quantity: 1)
      allow(::Stripe::Checkout::Session).to receive(:create).and_return(checkout_session)
    end

    context 'success path' do
      it 'creates checkout session with order products and delivery line item' do
        subject

        expect(::Stripe::Checkout::Session).to have_received(:create).with(
          mode: 'payment',
          payment_method_types: Payment::STRIPE_AVAILABLE_METHODS,
          line_items: [
            {
              quantity: 2,
              price_data: {
                currency: 'pln',
                unit_amount: 21_524,
                product_data: { name: 'Grunt' }
              }
            },
            {
              quantity: 1,
              price_data: {
                currency: 'pln',
                unit_amount: 1_513,
                product_data: { name: 'Klej' }
              }
            },
            {
              quantity: 1,
              price_data: {
                currency: 'pln',
                unit_amount: 1_352,
                product_data: { name: 'Dostawa: Paczkomat InPost' }
              }
            }
          ],
          success_url: "#{Rails.configuration.x.frontend_url}/thank-you-page?order_id=#{order.id}",
          cancel_url: "#{Rails.configuration.x.frontend_url}/",
          metadata: { order_id: order.id }
        )
      end

      it 'returns created checkout session' do
        expect(subject).to eq(checkout_session)
      end
    end

    context 'when delivery method has zero price' do
      let(:delivery_method) { 'pick_up_at_the_point' }

      it 'does not add delivery line item' do
        subject

        expected_line_items = [
          {
            quantity: 2,
            price_data: {
              currency: 'pln',
              unit_amount: 21_524,
              product_data: { name: 'Grunt' }
            }
          },
          {
            quantity: 1,
            price_data: {
              currency: 'pln',
              unit_amount: 1_513,
              product_data: { name: 'Klej' }
            }
          }
        ]

        expect(::Stripe::Checkout::Session).to have_received(:create).with(
          hash_including(line_items: expected_line_items)
        )
      end
    end
  end
end
