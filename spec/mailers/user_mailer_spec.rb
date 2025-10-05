describe UserMailer, type: :mailer do
  describe '#account_registered' do
    subject { described_class.with(email: email, password: password).account_registered.deliver_now }

    let(:email) { 'john.doe@example.com' }
    let(:password) { 'Password1!' }

    it { expect(subject.subject).to eq('Dziękujemy za rejestrację w naszym serwisie!') }
    it { expect(subject.to).to eq([email]) }
    it { expect(subject.from).to eq('Sklep budowlany Budoman') }
  end
end
