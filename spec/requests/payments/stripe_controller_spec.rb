# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Payments::StripeController', type: :request do
  describe 'POST /payments/stripe/update_status' do
    subject { post '/payments/stripe/update_status', params: {}, headers: { 'Stripe-Signature' => 'test-signature' } }

    let(:event) do
      session_object = double('Stripe::Checkout::Session', id: 'cs_test_123', payment_status: 'paid')
      event_data = double('Stripe::Event::Data', object: session_object)
      double('Stripe::Event', type: 'checkout.session.completed', data: event_data)
    end

    let(:webhook_service) { instance_double(Payments::Stripe::HandleWebhookService) }

    before do
      allow(::Stripe::Webhook).to receive(:construct_event).and_return(event)
      allow(Payments::Stripe::HandleWebhookService).to receive(:new).with(event: event).and_return(webhook_service)
    end

    context 'success path' do
      before do
        allow(webhook_service).to receive(:call)
        allow(webhook_service).to receive(:success?).and_return(true)
        allow(webhook_service).to receive(:errors).and_return([])
      end

      it 'returns ok' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'delegates event handling to HandleWebhookService' do
        subject
        expect(webhook_service).to have_received(:call)
      end
    end

    context 'failure path' do
      context 'when HandleWebhookService fails' do
        before do
          allow(webhook_service).to receive(:call)
          allow(webhook_service).to receive(:success?).and_return(false)
          allow(webhook_service).to receive(:errors).and_return(['Unsupported event type!'])
          allow(Rollbar).to receive(:error)
        end

        it 'returns unprocessable entity' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'reports service errors to Rollbar' do
          subject
          expect(Rollbar).to have_received(:error).with('Unsupported event type!')
        end
      end

      context 'when event verification fails' do
        before do
          allow(::Stripe::Webhook).to receive(:construct_event).and_raise(StandardError, 'Invalid signature')
          allow(webhook_service).to receive(:call)
          allow(Rollbar).to receive(:error)
        end

        it 'returns unprocessable entity' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'reports error to Rollbar' do
          subject
          expect(Rollbar).to have_received(:error) do |error|
            expect(error).to be_a(StandardError)
            expect(error.message).to eq('Invalid signature')
          end
        end

        it 'does not call HandleWebhookService' do
          subject
          expect(webhook_service).not_to have_received(:call)
        end
      end
    end
  end
end
