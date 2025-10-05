describe User, type: :model do
  subject { described_class.new(email: 'john.doe@example.com', password: 'Password1!') }

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:email).with_message('is already taken!') }
    it { is_expected.to allow_value('test@example.com').for(:email) }
    it { is_expected.not_to allow_value('test').for(:email) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:opinions).dependent(:destroy) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
  end
end
