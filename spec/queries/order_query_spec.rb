describe OrderQuery do
  describe '#call' do
    subject { described_class.new(params).call }

    let(:user1) { create(:user, email: 'user1@example.com') }
    let(:user2) { create(:user, email: 'user2@example.com') }
    let(:order1) { create(:order, user: user1, delivery_method: 'in_post') }
    let(:order2) { create(:order, user: user2, delivery_method: 'dpd') }
    let(:order3) { create(:order, user: user1, delivery_method: 'pick_up_at_the_point') }

    before do
      order1.update!(created_at: 3.days.ago)
      order2.update!(created_at: 2.days.ago)
      order3.update!(created_at: 1.day.ago)
    end

    context 'when no params are provided' do
      let(:params) { { input: {} } }

      it 'returns all orders sorted by creation date descending' do
        result = subject
        expect(result[:orders]).to eq([order3, order2, order1])
        expect(result[:quantity]).to eq(3)
      end
    end

    context 'when filtering by user_id' do
      let(:params) { { input: { user_id: user1.id } } }

      it 'returns only orders for specified user sorted by creation date descending' do
        result = subject
        expect(result[:orders]).to eq([order3, order1])
        expect(result[:quantity]).to eq(2)
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

      it 'returns paginated orders sorted by creation date descending' do
        result = subject
        expect(result[:orders]).to eq([order3, order2])
        expect(result[:quantity]).to eq(3)
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

      it 'returns orders from second page' do
        result = subject
        expect(result[:orders]).to eq([order1])
        expect(result[:quantity]).to eq(3)
      end
    end

    context 'when combining user filter and pagination' do
      let(:params) do
        {
          input: {
            user_id: user1.id,
            pagination: {
              page: 0,
              quantity_per_page: 1
            }
          }
        }
      end

      it 'returns paginated orders for user sorted by creation date descending' do
        result = subject
        expect(result[:orders]).to eq([order3])
        expect(result[:quantity]).to eq(2)
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

      it 'returns empty orders array with correct quantity' do
        result = subject
        expect(result[:orders]).to be_empty
        expect(result[:quantity]).to eq(3)
      end
    end

    context 'when quantity_per_page is larger than total orders' do
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

      it 'returns all orders' do
        result = subject
        expect(result[:orders]).to eq([order3, order2, order1])
        expect(result[:quantity]).to eq(3)
      end
    end

    context 'when no orders exist' do
      before { Order.destroy_all }

      let(:params) { { input: {} } }

      it 'returns empty result with zero quantity' do
        result = subject
        expect(result[:orders]).to be_empty
        expect(result[:quantity]).to eq(0)
      end
    end

    context 'when filtering by user with no orders' do
      let(:user_without_orders) { create(:user, email: 'no-orders@example.com') }
      let(:params) { { input: { user_id: user_without_orders.id } } }

      it 'returns empty orders array with zero quantity' do
        result = subject
        expect(result[:orders]).to be_empty
        expect(result[:quantity]).to eq(0)
      end
    end
  end
end
