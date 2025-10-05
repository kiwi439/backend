require 'rails_helper'

describe Services::StreamPlatform::PublishService, type: :service do
  describe '#call' do
    subject { described_class.call(topic: topic, payload: payload, log_file_name: log_file_name) }

    let(:topic) { 'monitor_resources' }
    let(:payload) { 'encoded' }
    let(:log_file_name) { 'monitoring_system.log' }
    let(:producer) { instance_double(WaterDrop::Producer) }
    let(:logger) { instance_double(Services::LoggerService) }

    before do
      allow(WaterDrop::Producer).to receive(:new).and_return(producer)
      allow(producer).to receive(:setup) do |&block|
        config = Struct.new(:deliver, :logger, :kafka).new
        block.call(config)
      end
      allow(Services::LoggerService).to receive(:new).with(log_path: log_file_name).and_return(logger)
    end

    context 'when publish succeeds' do
      it 'publishes message with producer and returns result' do
        expect(producer).to receive(:produce_sync).with(topic: topic, payload: payload).and_return(true)
        expect(subject).to eq(true)
      end
    end

    context 'when producer raises error' do
      before do
        allow(producer).to receive(:produce_sync).and_raise(StandardError, 'failure')
      end

      it 'raises PublishOnStreamPlatformError' do
        expect { subject }.to raise_error(Services::StreamPlatform::PublishService::PublishOnStreamPlatformError)
      end
    end
  end
end
