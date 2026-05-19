# frozen_string_literal: true

describe Invoice, type: :model do
  subject { build(:invoice) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:provider_name) }
    it { is_expected.to validate_inclusion_of(:provider_name).in_array(Invoice::ALLOWED_PROVIDERS) }

    it { is_expected.to validate_presence_of(:external_uuid) }
    it { is_expected.to validate_uniqueness_of(:external_uuid) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:order) }
  end
end
