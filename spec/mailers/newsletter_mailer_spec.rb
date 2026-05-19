# frozen_string_literal: true

describe NewsletterMailer, type: :mailer do
  describe '#send_newsletter' do
    subject { described_class.with(newsletter: newsletter).send_newsletter.deliver_now }

    let(:newsletter) { create(:newsletter) }
    let(:attachment_service) { instance_double(Mails::Attachments::SendNewsletterService) }

    before do
      allow(Mails::Attachments::SendNewsletterService).to receive(:new).and_return(attachment_service)
    end

    context 'success path' do
      before do
        allow(attachment_service).to receive(:call).and_return([{ file_name: 'Prezentacja budowlana.pptx', content: 'ppt_content' }])
        allow(attachment_service).to receive(:success?).and_return(true)
        allow(attachment_service).to receive(:errors).and_return([])
      end

      it { expect(subject.subject).to eq('Cotygodniowy newsletter!') }
      it { expect(subject.to).to eq([newsletter.email]) }
      it { expect(subject.from).to eq('Sklep budowlany Budoman') }

      it { expect(subject.attachments.count).to eq(1) }
      it { expect(subject.attachments.first.filename).to eq('Prezentacja budowlana.pptx') }
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
