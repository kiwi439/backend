describe Services::Monitoring::HandleMonitorResourcesService, type: :service do
  describe '#call' do
    subject { described_class.call(params: params) }

    let(:params) { { sample: 'data' } }
    let(:logger) { instance_double(Services::LoggerService) }
    let(:built_payload) { { payload: 'built' } }
    let(:encoded_payload) { 'encoded-payload' }

    before do
      allow(Services::Monitoring::BuildMonitoringPayloadService).to receive(:call).with(params: params).and_return(built_payload)
      allow(Services::StreamPlatform::ValidateAndEncodePayloadService).to receive(:call).with(payload: built_payload, schema_name: 'monitor_resources').and_return(encoded_payload)
      allow(Services::StreamPlatform::PublishService).to receive(:call).with(topic: 'monitor_resources', payload: encoded_payload, log_file_name: 'monitoring_system.log').and_return(true)
      allow(Services::LoggerService).to receive(:new).with(log_path: 'monitoring_system.log').and_return(logger)
      allow(Rollbar).to receive(:warn)
    end

    context 'success path' do
      before { allow(logger).to receive(:info).and_return(true) }

      it { is_expected.to eq(true) }

      it 'logs success info' do
        expect(logger).to receive(:info).with(message: 'Event succesfully published on stream platform!')
        subject
      end
    end

    context 'failure path' do
      before do
        allow(Services::StreamPlatform::PublishService).to receive(:call).and_raise(StandardError, 'Something went wrong!')
        allow(logger).to receive(:warn)
      end

      it { is_expected.to eq(false) }

      it 'logs error info and reports to Rollbar' do
        expect(logger).to receive(:warn).with(message: /Event publication failed!/)
        expect(Rollbar).to receive(:warn)
        subject
      end
    end
  end
end
