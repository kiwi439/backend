require 'rails_helper'

describe Graphql::ExecuteQueryService, type: :service do
  describe '#call' do
    subject { described_class.call(context: context) }

    let(:context) do
      {
        query: 'query { users { id } }',
        variables: {},
        context: { session: {}, current_user: nil },
        operation_name: 'User'
      }
    end

    context 'success path' do
      let(:response) { { 'data' => { 'user' => { 'id' => 1 } } } }

      before do
        allow(BudomanBackendSchema).to receive(:execute).and_return(response)
      end

      it 'calls BudomanBackendSchema.execute with correct parameters' do
        expect(BudomanBackendSchema).to receive(:execute).with(context[:query],
                                                               variables: context[:variables],
                                                               context: context[:context],
                                                               operation_name: context[:operation_name])
        subject
      end

      it 'returns the result' do
        expect(subject).to eq(response)
      end
    end

    context 'error path' do
      let(:result) do
        {
          'data' => nil,
          'errors' => [
            { 'message' => 'Something went wrong' },
            { 'message' => 'Another error' }
          ]
        }
      end

      before do
        allow(BudomanBackendSchema).to receive(:execute).and_return(result)
      end

      it 'raises StandardError with errors' do
        expect { subject }.to raise_error(StandardError, result['errors'].to_s)
      end
    end
  end
end
