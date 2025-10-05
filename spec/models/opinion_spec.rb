describe Opinion, type: :model do
  describe 'validations' do
    subject { described_class.new(content: 'Great product', mark: 5, user: build(:user)) }

    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_inclusion_of(:mark).in_range(1..5) }

    it { is_expected.to allow_value(1).for(:mark) }
    it { is_expected.to allow_value(5).for(:mark) }
    it { is_expected.not_to allow_value(0).for(:mark) }
    it { is_expected.not_to allow_value(6).for(:mark) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
