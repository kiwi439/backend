# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Payments::StripeController', type: :request do
  describe 'POST /payments/stripe/update_status' do
    subject { post '/payments/stripe/update_status', params: {}, headers: { 'Stripe-Signature' => 'test-signature' } }

    let(:payment) { create(:payment, provider_data: { checkout_session_id: session_id }) }
    let(:session_id) { 'cs_test_123' }
    let(:event) do
      session_object = double('Stripe::Checkout::Session', id: session_id, payment_status: payment_status)
      event_data = double('Stripe::Event::Data', object: session_object)
      double('Stripe::Event', type: event_type, data: event_data)
    end

    before do
      allow(ENV).to receive(:fetch).with('STRIPE_WEBHOOK_SIGNING_SECRET').and_return('whsec_test')
      allow(::Stripe::Webhook).to receive(:construct_event).and_return(event)
      payment
    end

    context 'success_path' do
      context 'when checkout.session.completed event is received' do
        let(:event_type) { 'checkout.session.completed' }
        let(:payment_status) { 'paid' }

        it 'updates payment status to succeeded and returns ok' do
          subject
          expect(response).to have_http_status(:ok)
          expect(payment.reload.status).to eq('succeeded')
        end
      end

      context 'when checkout.session.expired event is received' do
        let(:event_type) { 'checkout.session.expired' }
        let(:payment_status) { 'unpaid' }

        it 'updates payment status to expired and returns ok' do
          subject
          expect(response).to have_http_status(:ok)
          expect(payment.reload.status).to eq('expired')
        end
      end
    end

    context 'failure_path' do
      context 'when unsupported event type is received' do
        let(:event_type) { 'payment_intent.succeeded' }
        let(:payment_status) { 'paid' }

        it 'returns unprocessable entity and reports error' do
          expect(Rollbar).to receive(:error) do |error|
            expect(error).to be_a(StandardError)
            expect(error.message).to eq('Unsupported event type!')
          end

          subject

          expect(response).to have_http_status(:unprocessable_entity)
          expect(payment.reload.status).to eq('pending')
        end
      end
    end
  end
end
