require 'rails_helper'

describe Services::Aws::LambdaService, type: :service do
  describe '#call' do
    subject { described_class.call(function_name: function_name, payload: payload) }

    let(:function_name) { 'TestFunction' }
    let(:payload) { { test: 'data' } }
    let(:logger_service) { instance_double(Services::LoggerService) }
    let(:mock_client) { instance_double(Aws::Lambda::Client) }

    before do
      allow(Services::LoggerService).to receive(:new).and_return(logger_service)
      allow(logger_service).to receive(:error)
      allow(Rollbar).to receive(:error)
      allow(FileUtils).to receive(:mkdir_p)
      allow(Dir).to receive(:exist?).and_return(true)
      allow(Aws::Lambda::Client).to receive(:new).and_return(mock_client)
    end

    context 'when Lambda function succeeds' do
      let(:mock_response) do
        instance_double(Aws::Lambda::Types::InvocationResponse,
          log_result: Base64.encode64('Test logs'),
          payload: StringIO.new('{"result": "success"}'),
          function_error: nil
        )
      end

      before do
        allow(mock_client).to receive(:invoke).and_return(mock_response)
      end

      it 'returns logs and body_response' do
        expect(subject).to eq({ logs: 'Test logs', body_response: { 'result' => 'success' } })
      end

      it 'does not log any errors' do
        expect(logger_service).not_to receive(:error)
        expect(Rollbar).not_to receive(:error)
        subject
      end
    end

    context 'when Lambda function fails' do
      let(:error_response) do
        instance_double(Aws::Lambda::Types::InvocationResponse,
          log_result: Base64.encode64('Error logs'),
          payload: StringIO.new('{"errorMessage": "Test error", "errorType": "RuntimeError"}'),
          function_error: 'Unhandled'
        )
      end

      before do
        allow(mock_client).to receive(:invoke).and_return(error_response)
      end

      it 'logs error to file' do
        expect(Services::LoggerService).to receive(:new).with(file_name: 'lambda/test_function.log')
        expect(logger_service).to receive(:error).with(message: include('TestFunction error occured!'))
        expect { subject }.to raise_error(Services::Aws::LambdaService::PerformingLambdaFunctionError)
      end

      it 'logs error to Rollbar' do
        expect(Rollbar).to receive(:error)
        expect { subject }.to raise_error(Services::Aws::LambdaService::PerformingLambdaFunctionError)
      end

      it 'raises PerformingLambdaFunctionError' do
        expect { subject }.to raise_error(Services::Aws::LambdaService::PerformingLambdaFunctionError)
      end
    end

    context 'when Lambda service raises StandardError' do
      before do
        allow(mock_client).to receive(:invoke).and_raise(StandardError, 'Service error')
      end

      it 'logs error to file' do
        expect(Services::LoggerService).to receive(:new).with(file_name: 'lambda/test_function.log')
        expect(logger_service).to receive(:error).with(message: include('TestFunction error occured!'))
        expect { subject }.to raise_error(Services::Aws::LambdaService::PerformingLambdaFunctionError)
      end

      it 'logs error to Rollbar' do
        expect(Rollbar).to receive(:error)
        expect { subject }.to raise_error(Services::Aws::LambdaService::PerformingLambdaFunctionError)
      end

      it 'raises PerformingLambdaFunctionError' do
        expect { subject }.to raise_error(Services::Aws::LambdaService::PerformingLambdaFunctionError)
      end
    end
  end
end
