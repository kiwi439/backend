describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).with_message('is already taken!') }
    it { is_expected.to allow_value('test@example.com').for(:email) }
    it { is_expected.not_to allow_value('test').for(:email) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:surname) }
    it { is_expected.to validate_presence_of(:street) }
    it { is_expected.to validate_presence_of(:city) }
    
    it { is_expected.not_to allow_value('abc').for(:phone_number) }
    it { is_expected.not_to allow_value('123-456-789').for(:phone_number) }
    it { is_expected.not_to allow_value('12345678').for(:phone_number) }
    it { is_expected.not_to allow_value('1234567890').for(:phone_number) }
    it { is_expected.to allow_value('123456789').for(:phone_number) }
    it { is_expected.to allow_value(nil).for(:phone_number) }
    it { is_expected.to allow_value('').for(:phone_number) }
    
    it { is_expected.not_to allow_value('34300').for(:postal_code) }
    it { is_expected.not_to allow_value('ab-cde').for(:postal_code) }
    it { is_expected.to allow_value('34-300').for(:postal_code) }
    it { is_expected.to allow_value(nil).for(:postal_code) }
    it { is_expected.to allow_value('').for(:postal_code) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:opinions).dependent(:destroy) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
  end
end
