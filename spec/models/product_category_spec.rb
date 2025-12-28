describe ProductCategory, type: :model do
  subject { described_class.new(name: 'Stairway') }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:products) }
  end
end
