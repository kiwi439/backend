require 'rails_helper'

describe Graphql::PrepareContextService, type: :service do
  describe '#call' do
    subject { described_class.call(params: params, session: session) }

    let(:params) { { query: 'query { users { id } }' } }
    let(:session) { {} }
    let(:user_session_service) { instance_double(Session::UserSessionService) }

    before do
      allow(Session::UserSessionService).to receive(:new).and_return(user_session_service)
      allow(user_session_service).to receive(:current_user).and_return(nil)
    end

    context 'success path' do
      context 'with basic params' do
        it 'returns context with query' do
          result = subject
          expect(result[:query]).to eq('query { users { id } }')
        end

        it 'returns context with default variables' do
          result = subject
          expect(result[:variables]).to eq({})
        end

        it 'returns context with default operation_name' do
          result = subject
          expect(result[:operation_name]).to be_nil
        end

        it 'returns context with session and current_user' do
          result = subject
          expect(result[:context]).to eq({ session: session, current_user: nil })
        end

        it 'calls UserSessionService to get current_user' do
          expect(Session::UserSessionService).to receive(:new).with(session: session)
          expect(user_session_service).to receive(:current_user)
          subject
        end
      end

      context 'with operationName' do
        let(:params) { { query: 'query { users { id } }', operationName: 'GetUsers' } }

        it 'returns context with operation_name' do
          result = subject
          expect(result[:operation_name]).to eq('GetUsers')
        end
      end

      context 'with variables as Hash' do
        let(:params) { { query: 'query { users { id } }', variables: { id: 1 } } }

        it 'returns context with parsed variables' do
          result = subject
          expect(result[:variables]).to eq({ id: 1 })
        end
      end

      context 'with variables as String' do
        let(:params) { { query: 'query { users { id } }', variables: '{"id": 1}' } }

        it 'returns context with parsed JSON variables' do
          result = subject
          expect(result[:variables]).to eq({ 'id' => 1 })
        end
      end

      context 'with variables as empty String' do
        let(:params) { { query: 'query { users { id } }', variables: '' } }

        it 'returns context with empty variables' do
          result = subject
          expect(result[:variables]).to eq({})
        end
      end

      context 'with variables as ActionController::Parameters' do
        let(:params) { { query: 'query { users { id } }', variables: ActionController::Parameters.new({ id: 1 }) } }

        it 'returns context with converted variables' do
          result = subject
          expect(result[:variables]).to eq({ 'id' => 1 })
        end
      end

      context 'with variables as nil' do
        let(:params) { { query: 'query { users { id } }', variables: nil } }

        it 'returns context with empty variables' do
          result = subject
          expect(result[:variables]).to eq({})
        end
      end

      context 'with current_user' do
        let(:user) { create(:user) }

        before do
          allow(user_session_service).to receive(:current_user).and_return(user)
        end

        it 'returns context with current_user' do
          result = subject
          expect(result[:context][:current_user]).to eq(user)
        end
      end
    end

    context 'error path' do
      context 'when query is missing' do
        let(:params) { {} }

        it 'raises KeyError' do
          expect { subject }.to raise_error(KeyError)
        end
      end

      context 'when variables is unexpected type' do
        let(:params) { { query: 'query { users { id } }', variables: [] } }

        it 'raises ArgumentError' do
          expect { subject }.to raise_error(ArgumentError, 'Unexpected parameter: []')
        end
      end
    end
  end
end

