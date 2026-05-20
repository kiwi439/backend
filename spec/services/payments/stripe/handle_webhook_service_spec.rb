# frozen_string_literal: true

describe Payments::Stripe::HandleWebhookService, type: :service do
  describe '#call' do
    subject(:service) { described_class.new(event:) }

    context 'success path' do
      context 'checkout.session.completed' do
        let(:event) do
          session = double('Stripe::Checkout::Session', id: 'cs_test_123', payment_status: 'paid')
          event_data = double('Stripe::StripeObject', object: session)
          double('Stripe::Event', type: 'checkout.session.completed', data: event_data)
        end

        let(:payment) { create(:payment, status: :pending, provider_data: { checkout_session_id: 'cs_test_123' }) }
        let(:create_invoice_service) { instance_double(Invoices::Infakt::CreateInvoiceService) }
        let(:mailer) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        before do
          payment
          allow(Invoices::Infakt::CreateInvoiceService).to receive(:new).with(order: payment.order).and_return(create_invoice_service)
          allow(create_invoice_service).to receive(:call).and_return({ 'uuid' => 'infakt-invoice-uuid' })
          allow(create_invoice_service).to receive(:success?).and_return(true)
          allow(create_invoice_service).to receive(:errors).and_return([])
          allow(OrderMailer).to receive(:with).with(order: payment.order).and_return(OrderMailer)
          allow(OrderMailer).to receive(:order_created).and_return(mailer)
        end

        it 'is successful' do
          service.call
          expect(service.success?).to be(true)
        end

        it 'updates payment status to succeeded' do
          expect(payment.status).to eq('pending')
          service.call
          expect(payment.reload.status).to eq('succeeded')
        end

        it 'creates invoice' do
          expect(Invoice.count).to eq(0)
          service.call
          invoice = Invoice.last
          expect(Invoice.count).to eq(1)
          expect(invoice.order).to eq(payment.order)
          expect(invoice.external_uuid).to eq('infakt-invoice-uuid')
        end

        it 'sends order created email' do
          service.call
          expect(mailer).to have_received(:deliver_later).with(queue: :order)
        end
      end

      context 'checkout.session.expired' do
        let(:event) do
          session = double('Stripe::Checkout::Session', id: 'cs_test_123', payment_status: 'unpaid')
          event_data = double('Stripe::StripeObject', object: session)
          double('Stripe::Event', type: 'checkout.session.expired', data: event_data)
        end

        let(:payment) { create(:payment, status: :pending, provider_data: { checkout_session_id: 'cs_test_123' }) }

        before { payment }

        it 'is successful' do
          service.call
          expect(service.success?).to be(true)
        end

        it 'updates payment status to expired' do
          expect(payment.status).to eq('pending')
          service.call
          expect(payment.reload.status).to eq('expired')
        end
      end
    end

    context 'failure path' do
      context 'when Infakt invoice creation fails' do
        let(:event) do
          session = double('Stripe::Checkout::Session', id: 'cs_test_123', payment_status: 'paid')
          event_data = double('Stripe::StripeObject', object: session)
          double('Stripe::Event', type: 'checkout.session.completed', data: event_data)
        end

        let(:payment) { create(:payment, status: :pending, provider_data: { checkout_session_id: 'cs_test_123' }) }
        let(:create_invoice_service) { instance_double(Invoices::Infakt::CreateInvoiceService) }
        let(:mailer) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        before do
          payment
          allow(Invoices::Infakt::CreateInvoiceService).to receive(:new).with(order: payment.order).and_return(create_invoice_service)
          allow(create_invoice_service).to receive(:call).and_return(nil)
          allow(create_invoice_service).to receive(:success?).and_return(false)
          allow(create_invoice_service).to receive(:errors).and_return(['API error'])
          allow(OrderMailer).to receive(:with).with(order: payment.order).and_return(OrderMailer)
          allow(OrderMailer).to receive(:order_created).and_return(mailer)
        end

        it 'is not successful and records error message' do
          service.call
          expect(service.success?).to be(false)
          expect(service.errors).to eq(['API error'])
        end

        it 'does not update payment status' do
          expect(payment.status).to eq('pending')
          service.call
          expect(payment.reload.status).to eq('pending')
        end

        it 'does not create invoice' do
          expect(Invoice.count).to eq(0)
          service.call
          expect(Invoice.count).to eq(0)
        end

        it 'does not send order created email' do
          service.call
          expect(mailer).not_to have_received(:deliver_later)
        end
      end

      context 'when local invoice creation fails' do
        let(:event) do
          session = double('Stripe::Checkout::Session', id: 'cs_test_123', payment_status: 'paid')
          event_data = double('Stripe::StripeObject', object: session)
          double('Stripe::Event', type: 'checkout.session.completed', data: event_data)
        end

        let(:payment) { create(:payment, status: :pending, provider_data: { checkout_session_id: 'cs_test_123' }) }
        let(:create_invoice_service) { instance_double(Invoices::Infakt::CreateInvoiceService) }
        let(:mailer) { instance_double(ActionMailer::MessageDelivery, deliver_later: true) }

        before do
          payment
          allow(Invoices::Infakt::CreateInvoiceService).to receive(:new).with(order: payment.order).and_return(create_invoice_service)
          allow(create_invoice_service).to receive(:call).and_return({ 'uuid' => 'infakt-invoice-uuid' })
          allow(create_invoice_service).to receive(:success?).and_return(true)
          allow(create_invoice_service).to receive(:errors).and_return([])
          allow(Invoice).to receive(:create!).and_raise(
            ActiveRecord::RecordInvalid.new(
              Invoice.new(order: payment.order, provider_name: Invoice::INFAKT_PROVIDER, external_uuid: 'infakt-invoice-uuid')
            )
          )
          allow(OrderMailer).to receive(:with).with(order: payment.order).and_return(OrderMailer)
          allow(OrderMailer).to receive(:order_created).and_return(mailer)
        end

        it 'is not successful and records error message' do
          service.call
          expect(service.success?).to be(false)
          expect(service.errors.first).to include('Validation failed')
        end

        it 'rolls back payment status update' do
          expect(payment.status).to eq('pending')
          service.call
          expect(payment.reload.status).to eq('pending')
        end

        it 'does not create invoice' do
          expect(Invoice.count).to eq(0)
          service.call
          expect(Invoice.count).to eq(0)
        end

        it 'does not send order created email' do
          service.call
          expect(mailer).not_to have_received(:deliver_later)
        end
      end

      context 'when unsupported event type is received' do
        let(:event) do
          session = double('Stripe::Checkout::Session', id: 'cs_test_123', payment_status: 'paid')
          event_data = double('Stripe::StripeObject', object: session)
          double('Stripe::Event', type: 'payment_intent.succeeded', data: event_data)
        end

        let(:payment) { create(:payment, status: :pending, provider_data: { checkout_session_id: 'cs_test_123' }) }

        before { payment }

        it 'is not successful and records error message' do
          service.call
          expect(service.success?).to be(false)
          expect(service.errors).to eq(['Unsupported event type!'])
        end

        it 'does not update payment status' do
          expect(payment.status).to eq('pending')
          service.call
          expect(payment.reload.status).to eq('pending')
        end
      end

      context 'when payment is not found' do
        let(:event) do
          session = double('Stripe::Checkout::Session', id: 'missing-session-id', payment_status: 'paid')
          event_data = double('Stripe::StripeObject', object: session)
          double('Stripe::Event', type: 'checkout.session.completed', data: event_data)
        end

        it 'is not successful and records error message' do
          service.call
          expect(service.success?).to be(false)
          expect(service.errors.first).to include("Couldn't find Payment")
        end
      end
    end
  end
end
