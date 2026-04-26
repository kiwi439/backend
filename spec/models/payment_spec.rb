describe Payment, type: :model do
  subject { build(:payment) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_inclusion_of(:provider).in_array(Payment::PROVIDERS) }

    it { is_expected.to validate_presence_of(:amount_cents) }
    it { is_expected.to validate_numericality_of(:amount_cents).only_integer }
    it { is_expected.to validate_numericality_of(:amount_cents).is_greater_than_or_equal_to(0) }

    it 'allows valid statuses' do
      %w[pending succeeded failed expired].each do |status|
        subject.status = status
        expect(subject).to be_valid
      end
    end

    it 'does not allow invalid status' do
      subject.status = 'unknown'
      expect(subject).not_to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:order) }
  end
end
