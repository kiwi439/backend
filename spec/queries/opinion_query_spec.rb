describe OpinionQuery do
  describe '#call' do
    subject { described_class.new(params).call }

    let(:user1) { create(:user, email: 'user1@example.com') }
    let(:user2) { create(:user, email: 'user2@example.com') }
    let(:opinion1) { create(:opinion, user: user1, content: 'First opinion', mark: 5) }
    let(:opinion2) { create(:opinion, user: user2, content: 'Second opinion', mark: 4) }
    let(:opinion3) { create(:opinion, user: user1, content: 'Third opinion', mark: 3) }

    before do
      opinion1.update!(created_at: 3.days.ago)
      opinion2.update!(created_at: 2.days.ago)
      opinion3.update!(created_at: 1.day.ago)
    end

    context 'when no pagination params are provided' do
      let(:params) { { input: {} } }

      it 'returns all opinions sorted by creation date' do
        expect(subject).to eq([opinion1, opinion2, opinion3])
      end
    end

    context 'when pagination params are provided' do
      let(:params) do
        {
          input: {
            pagination: {
              page: 0,
              quantity_per_page: 2
            }
          }
        }
      end

      it 'returns paginated opinions sorted by creation date' do
        expect(subject).to eq([opinion1, opinion2])
      end
    end

    context 'when requesting second page' do
      let(:params) do
        {
          input: {
            pagination: {
              page: 1,
              quantity_per_page: 2
            }
          }
        }
      end

      it 'returns opinions from second page' do
        expect(subject).to eq([opinion3])
      end
    end

    context 'when quantity_per_page is larger than total opinions' do
      let(:params) do
        {
          input: {
            pagination: {
              page: 0,
              quantity_per_page: 10
            }
          }
        }
      end

      it 'returns all opinions' do
        expect(subject).to eq([opinion1, opinion2, opinion3])
      end
    end

    context 'when requesting page beyond available data' do
      let(:params) do
        {
          input: {
            pagination: {
              page: 5,
              quantity_per_page: 2
            }
          }
        }
      end

      it 'returns empty collection' do
        expect(subject).to be_empty
      end
    end

    context 'when no opinions exist' do
      before { Opinion.destroy_all }

      let(:params) { { input: {} } }

      it 'returns empty collection' do
        expect(subject).to be_empty
      end
    end
  end
end
