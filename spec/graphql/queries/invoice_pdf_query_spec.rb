# frozen_string_literal: true

describe Queries::InvoicePdfQuery, type: :request do
  describe 'request' do
    subject { post '/graphql', params: { query: query } }

    let(:query) do
      <<~GQL
        query {
          invoicePdf(orderId: "#{order.id}") {
            pdfBase64
          }
        }
      GQL
    end

    let(:user) { create(:user) }
    let(:order) { create(:order, user:) }
    let(:external_uuid) { 'infakt-invoice-uuid' }
    let(:fetch_service) { instance_double(Invoices::Infakt::FetchInvoiceService) }
    let(:session_service) { instance_double(Session::UserSessionService) }

    before do
      allow(Session::UserSessionService).to receive(:new).and_return(session_service)
      allow(session_service).to receive(:current_user).and_return(current_user)
    end

    context 'success path' do
      let(:current_user) { user }

      before do
        create(:invoice, order:, external_uuid:)
        allow(Invoices::Infakt::FetchInvoiceService).to receive(:new).with(external_uuid).and_return(fetch_service)
        allow(fetch_service).to receive(:call).and_return(instance_double(HTTParty::Response, body: 'pdf_binary_content'))
        allow(fetch_service).to receive(:success?).and_return(true)
        allow(fetch_service).to receive(:errors).and_return([])
        subject
      end

      it 'returns proper http status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns invoice PDF as Base64' do
        expected_response = {
          data: {
            invoicePdf: {
              pdfBase64: Base64.strict_encode64('pdf_binary_content')
            }
          }
        }

        expect(parse_request_body).to eq(expected_response)
      end
    end

    context 'when user is not authenticated' do
      let(:current_user) { nil }

      before { subject }

      it 'returns internal server error' do
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'returns error message' do
        expect(parse_request_body[:errors].first[:message]).to include('Unauthorized')
      end
    end

    context 'when Infakt fetch fails' do
      let(:current_user) { user }

      before do
        create(:invoice, order:, external_uuid:)
        allow(Invoices::Infakt::FetchInvoiceService).to receive(:new).with(external_uuid).and_return(fetch_service)
        allow(fetch_service).to receive(:call).and_return(nil)
        allow(fetch_service).to receive(:success?).and_return(false)
        allow(fetch_service).to receive(:errors).and_return(['API error'])
        subject
      end

      it 'returns internal server error' do
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'returns error message' do
        expect(parse_request_body[:errors].first[:message]).to include('API error')
      end
    end
  end
end
