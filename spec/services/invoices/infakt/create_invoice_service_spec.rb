# frozen_string_literal: true

describe Invoices::Infakt::CreateInvoiceService, type: :service do
  describe '#call' do
    subject { service.call }

    let(:service) { described_class.new(order:) }
    let(:order) { create(:order) }
    let(:product_1) { create(:product, name: 'Grunt', price: 174.99) }
    let(:product_2) { create(:product, name: 'Klej', price: 12.3) }

    before do
      create(:products_order, order:, product: product_1, product_quantity: 2)
      create(:products_order, order:, product: product_2, product_quantity: 1)
      create(:payment, order:, amount_cents: 45_913)
    end

    context 'success path' do
      let(:response) do
        instance_double(HTTParty::Response, success?: true,
                                            parsed_response: { 'uuid' => 'new-invoice-uuid' })
      end

      before do
        allow(HTTParty).to receive(:post).and_return(response)
      end

      it 'is successful' do
        subject
        expect(service.success?).to be(true)
      end

      it 'returns HTTParty response' do
        expect(subject).to eq(response)
      end

      it 'calls Infakt create invoice endpoint with invoice payload' do
        subject

        expect(HTTParty).to have_received(:post).with(
          "#{Rails.application.config.x.infakt_api_url}/api/v3/invoices.json",
          headers: {
            'X-inFakt-ApiKey' => ENV.fetch('INFAKT_API_KEY'),
            'Content-Type' => 'application/json; charset=utf-8',
            'Accept' => 'application/json'
          },
          body: satisfy do |json|
            expect(JSON.parse(json)).to include(
              'invoice' => hash_including(
                'paid_price' => 45_913,
                'services' => array_including(
                  hash_including('name' => 'Grunt', 'gross_price' => 43_048),
                  hash_including('name' => 'Klej', 'gross_price' => 1_513),
                  hash_including('name' => 'Dostawa: Paczkomat InPost', 'gross_price' => 1_352)
                )
              )
            )
          end
        )
      end

      context 'when delivery method has zero price' do
        let(:order) { create(:order, delivery_method: 'pick_up_at_the_point') }
        let(:response) do
          instance_double(HTTParty::Response, success?: true,
                                              parsed_response: { 'uuid' => 'new-invoice-uuid' })
        end
  
        before do
          allow(HTTParty).to receive(:post).and_return(response)
        end
  
        it 'is successful' do
          subject
          expect(service.success?).to be(true)
        end
  
        it 'does not add delivery line item' do
          subject
  
          expect(HTTParty).to have_received(:post).with(
            "#{Rails.application.config.x.infakt_api_url}/api/v3/invoices.json",
            headers: {
              'X-inFakt-ApiKey' => ENV.fetch('INFAKT_API_KEY'),
              'Content-Type' => 'application/json; charset=utf-8',
              'Accept' => 'application/json'
            },
            body: satisfy do |json|
              expect(JSON.parse(json)).to include(
                'invoice' => hash_including(
                  'paid_price' => 45_913,
                  'services' => contain_exactly(
                    hash_including('name' => 'Grunt', 'gross_price' => 43_048),
                    hash_including('name' => 'Klej', 'gross_price' => 1_513)
                  )
                )
              )
            end
          )
        end
      end
    end

    context 'failure path' do
      let(:response) do
        instance_double(HTTParty::Response, success?: false,
                                            parsed_response: { 'error' => 'Invalid invoice data' })
      end

      before do
        allow(HTTParty).to receive(:post).and_return(response)
      end

      it 'is not successful' do
        subject
        expect(service.success?).to be(false)
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end

      it 'records API error' do
        subject
        expect(service.errors).to eq([{ 'error' => 'Invalid invoice data' }])
      end
    end
  end
end
