describe Newsletter, type: :model do
  describe 'validations' do
    subject { described_class.new(name: 'John', surname: 'Doe', email: 'john.doe@example.com') }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:surname) }
    it { is_expected.to validate_presence_of(:email) }

    it { is_expected.to validate_uniqueness_of(:email).with_message('is already taken!') }

    it { is_expected.to allow_value('test@example.com').for(:email) }
    it { is_expected.not_to allow_value('invalid_email').for(:email).with_message('is invalid') }
  end
end
