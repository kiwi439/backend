describe Orders::SubmitOrderService, type: :service do
  describe '#call' do
    subject { described_class.call(params:) }

    let(:user) { create(:user) }
    let(:product) { create(:product, available_quantity: 10) }
    let(:session) do
      double('Stripe::Checkout::Session', id: 'cs_test_123',
                                          amount_total: 53597,
                                          currency: 'pln',
                                          url: 'https://checkout.stripe.com/c/pay/cs_test_123')
    end

    let(:params) do
      {
        name: 'John',
        surname: 'Doe',
        phone_number: '123456789',
        street: 'Main Street',
        city: 'Warsaw',
        postal_code: '00-001',
        delivery_method: 'in_post',
        email: 'john.doe@example.com',
        user: user,
        products_order: [
          {
            product_id: product.id,
            product_quantity: 3
          }
        ]
      }
    end

    before do
      allow(Payments::Stripe::CreateCheckoutSessionService).to receive(:call).and_return(session)
    end

    context 'success path' do
      it 'creates new order' do
        expect { subject }.to change { Order.count }.from(0).to(1)
      end

      it 'creates products_orders' do
        expect { subject }.to change { ProductsOrder.count }.from(0).to(1)
      end

      it 'updates product available quantity' do
        expect { subject }.to change { product.reload.available_quantity }.from(10).to(7)
      end

      it 'associates products with order' do
        subject
        result = Order.last
        expect(result.products_orders.count).to eq(1)
        expect(result.products_orders.first.product).to eq(product)
        expect(result.products_orders.first.product_quantity).to eq(3)
      end

      it 'associates payment with order' do
        expect { subject }.to change { Payment.count }.by(1)

        payment = Payment.last
        expect(payment.status).to eq('pending')
        expect(payment.provider).to eq('stripe')
        expect(payment.amount_cents).to eq(53597)
        expect(payment.provider_data).to eq({
          'checkout_session_id' => 'cs_test_123',
          'currency' => 'pln',
          'redirect_url' => 'https://checkout.stripe.com/c/pay/cs_test_123'
        })
      end

      it 'returns checkout session url' do
        result = subject
        expect(result).to eq('https://checkout.stripe.com/c/pay/cs_test_123')
      end
    end

    context 'failure path' do
      context 'when order creation fails due to validation' do
        before { params[:phone_number] = 'invalid' }

        it 'raises validation error' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'does not create order' do
          expect { subject rescue nil }.not_to change { Order.count }
        end

        it 'does not create products_orders' do
          expect { subject rescue nil }.not_to change { ProductsOrder.count }
        end

        it 'does not update product quantity' do
          expect { subject rescue nil }.not_to change { product.reload.available_quantity }
        end
      end

      context 'when order validation fails during save' do
        let(:params) do
          {
            name: 'John',
            surname: 'Doe',
            phone_number: '123456789',
            street: 'Main Street',
            city: 'Warsaw',
            postal_code: '00-001',
            delivery_method: 'in_post',
            email: 'john.doe@example.com',
            user: user,
            products_order: [
              {
                product_id: product.id,
                product_quantity: product.available_quantity + 1
              }
            ]
          }
        end

        it 'does not create order' do
          expect { subject rescue nil }.not_to change { Order.count }
        end

        it 'does not create products_orders' do
          expect { subject rescue nil }.not_to change { ProductsOrder.count }
        end

        it 'does not update product quantities' do
          expect { subject rescue nil }.not_to change { product.reload.available_quantity }
        end

        it 'raises validation error' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end
