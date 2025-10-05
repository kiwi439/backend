describe Orders::UploadInvoiceToStorageService, type: :service do
  describe '#call' do
    subject { described_class.call(order: order) }

    let(:user) { create(:user, id: 'b612c713-b328-43af-b8e2-c1704e68a463') }
    let(:order) { create(:order, id: '552967ef-8ed8-4b2f-8088-4e0ed5347660', user: user) }
    let(:s3_service) { instance_double(Services::Aws::S3Service, put_object: true) }
    let(:wicked_pdf) { instance_double(WickedPdf, pdf_from_string: 'pdf_content') }

    before do
      allow(Services::Aws::S3Service).to receive(:new).and_return(s3_service)
      allow(WickedPdf).to receive(:new).and_return(wicked_pdf)
      allow(File).to receive(:read).and_return('<html>Invoice template</html>')
      allow(ActionController::Base).to receive(:render).and_return('<html>Rendered invoice</html>')
    end

    context 'when invoice generation and upload succeeds' do
      it 'uploads invoice to storage with correct path' do
        expected_path = 'users/b612c713-b328-43af-b8e2-c1704e68a463/invoices/552967ef-8ed8-4b2f-8088-4e0ed5347660.pdf'
        expect(s3_service).to receive(:put_object).with(key: expected_path, body: 'pdf_content')
        subject
      end

      it 'generates PDF from template' do
        expect(WickedPdf).to receive(:new).and_return(wicked_pdf)
        expect(wicked_pdf).to receive(:pdf_from_string).with('<html>Rendered invoice</html>')
        subject
      end

      it 'reads invoice template file' do
        expect(File).to receive(:read).with('app/views/invoice.html.erb')
        subject
      end

      it 'renders template with order presenter' do
        expect(ActionController::Base).to receive(:render).with(inline: '<html>Invoice template</html>', locals: { presenter: instance_of(OrderPresenter) })
        subject
      end
    end

    context 'when PDF generation fails' do
      before do
        allow(WickedPdf).to receive(:new).and_raise(StandardError, 'PDF generation failed')
      end

      it 'raises GeneratingInvoicePayloadError' do
        expect { subject }.to raise_error(Orders::UploadInvoiceToStorageService::GeneratingInvoicePayloadError)
      end
    end

    context 'when template rendering fails' do
      before do
        allow(ActionController::Base).to receive(:render).and_raise(StandardError, 'Template rendering failed')
      end

      it 'raises GeneratingInvoicePayloadError' do
        expect { subject }.to raise_error(Orders::UploadInvoiceToStorageService::GeneratingInvoicePayloadError)
      end
    end

    context 'when S3 upload fails' do
      before do
        allow(s3_service).to receive(:put_object).and_raise(StandardError, 'S3 upload failed')
      end

      it 'raises S3 error' do
        expect { subject }.to raise_error(StandardError, 'S3 upload failed')
      end
    end
  end
end
