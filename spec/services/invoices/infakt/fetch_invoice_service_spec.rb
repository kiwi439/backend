# frozen_string_literal: true

describe Invoices::Infakt::FetchInvoiceService, type: :service do
  describe '#call' do
    subject { service.call }

    let(:service) { described_class.new(invoice_uuid) }
    let(:invoice_uuid) { 'infakt-invoice-uuid' }

    context 'success path' do
      let(:response) do
        instance_double(HTTParty::Response, success?: true,
                                            parsed_response: {},
                                            body: 'pdf_binary_content')
      end

      before do
        allow(HTTParty).to receive(:get).and_return(response)
      end

      it 'is successful' do
        subject
        expect(service.success?).to be(true)
      end

      it 'returns HTTParty response' do
        expect(subject).to eq(response)
      end

      it 'calls Infakt PDF endpoint' do
        subject

        expect(HTTParty).to have_received(:get).with(
          "#{Rails.application.config.x.infakt_api_url}/api/v3/invoices/#{invoice_uuid}/pdf.json",
          headers: {
            'X-inFakt-ApiKey' => ENV.fetch('INFAKT_API_KEY'),
            'Accept' => 'application/pdf'
          },
          query: { document_type: 'original' }
        )
      end
    end

    context 'failure path' do
      let(:response) do
        instance_double(HTTParty::Response, success?: false,
                                            parsed_response: { 'error' => 'Not found' },
                                            body: 'pdf_binary_content')
      end

      before do
        allow(HTTParty).to receive(:get).and_return(response)
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
        expect(service.errors).to eq([{ 'error' => 'Not found' }])
      end
    end
  end
end
