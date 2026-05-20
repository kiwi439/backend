# frozen_string_literal: true

describe OrderMailer, type: :mailer do
  describe '#order_created' do
    subject { described_class.with(order: order).order_created.deliver_now }

    let(:order) { create(:order) }
    let(:attachment_service) { instance_double(Mails::Attachments::OrderCreatedService) }

    before do
      allow(Mails::Attachments::OrderCreatedService).to receive(:new).and_return(attachment_service)
    end

    context 'success path' do
      before do
        allow(attachment_service).to receive(:call).and_return([{ file_name: 'Faktura.pdf', content: 'invoice_content' }])
        allow(attachment_service).to receive(:success?).and_return(true)
        allow(attachment_service).to receive(:errors).and_return([])
      end

      it { expect(subject.subject).to eq('Dziękujemy za zrealizowanie zamówienia!') }
      it { expect(subject.to).to eq(['john.doe123@gmail.com']) }
      it { expect(subject.from).to eq('Sklep budowlany Budoman') }

      it { expect(subject.attachments.count).to eq(1) }
      it { expect(subject.attachments.first.filename).to eq('Faktura.pdf') }
    end

    context 'failure path' do
      before do
        allow(attachment_service).to receive(:call).and_return([])
        allow(attachment_service).to receive(:success?).and_return(false)
        allow(attachment_service).to receive(:errors).and_return(['API error'])
      end

      it do
        expect(Rollbar).to receive(:error).with('API error')
        expect(subject).to be_nil
      end
    end
  end
end
