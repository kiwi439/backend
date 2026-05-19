# frozen_string_literal: true

describe Mails::Attachments::OrderCreatedService, type: :service do
  describe '#call' do
    subject { service.call }

    let(:service) { described_class.new(order: order) }
    let(:order) { create(:order) }
    let(:external_uuid) { 'infakt-invoice-uuid' }
    let(:fetch_service) { instance_double(Invoices::Infakt::FetchInvoiceService) }

    context 'success path' do
      let(:response) { instance_double(HTTParty::Response, body: 'pdf_binary_content') }

      before do
        create(:invoice, order:, external_uuid:)
        allow(Invoices::Infakt::FetchInvoiceService).to receive(:new).with(external_uuid).and_return(fetch_service)
        allow(fetch_service).to receive(:call).and_return(response)
        allow(fetch_service).to receive(:success?).and_return(true)
        allow(fetch_service).to receive(:errors).and_return([])
      end

      it 'is successful' do
        subject
        expect(service.success?).to be(true)
      end

      it 'returns invoice PDF as attachment' do
        expect(subject).to eq([{ file_name: 'Faktura.pdf', content: 'pdf_binary_content' }])
      end
    end

    context 'failure path' do
      context 'when Infakt fetch fails' do
        before do
          create(:invoice, order:, external_uuid:)
          allow(Invoices::Infakt::FetchInvoiceService).to receive(:new).with(external_uuid).and_return(fetch_service)
          allow(fetch_service).to receive(:call).and_return(nil)
          allow(fetch_service).to receive(:success?).and_return(false)
          allow(fetch_service).to receive(:errors).and_return(['API error'])
        end

        it 'is not successful' do
          subject
          expect(service.success?).to be(false)
        end

        it 'returns empty attachments' do
          expect(subject).to eq([])
        end

        it 'records error message' do
          subject
          expect(service.errors.size).to eq(1)
          expect(service.errors.first).to eq('Fetching invoice PDF from Infakt failed: API error')
        end
      end
    end
  end
end
