describe NewsletterMailer, type: :mailer do
  describe '#send_newsletter' do
    subject { described_class.with(newsletter: newsletter).send_newsletter.deliver_now }

    let(:newsletter) { create(:newsletter) }
    let(:attachment_service) { instance_double(Mails::Newsletter::GenerateAtachmentsForSendNewsletterService, call: [{ file_name: 'Prezentacja budowlana.pptx', content: 'ppt_content' }]) }

    before { allow(Mails::Newsletter::GenerateAtachmentsForSendNewsletterService).to receive(:new).and_return(attachment_service) }

    it { expect(subject.subject).to eq('Cotygodniowy newsletter!') }
    it { expect(subject.to).to eq([newsletter.email]) }
    it { expect(subject.from).to eq('Sklep budowlany Budoman') }

    it { expect(subject.attachments.count).to eq(1) }
    it { expect(subject.attachments.first.filename).to eq('Prezentacja budowlana.pptx') }
  end
end


