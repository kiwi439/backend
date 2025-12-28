require 'rails_helper'

describe Services::LoggerService, type: :service do
  subject { described_class.new(log_path: log_path) }

  let(:log_path) { 'test.log' }
  let(:mock_logger) { instance_double(Logger) }

  before do
    allow(Logger).to receive(:new).with(Rails.root.join('log', log_path)).and_return(mock_logger)
  end

  describe '#warn' do
    it 'delegates to logger warn method' do
      expect(mock_logger).to receive(:warn).with('warning message')
      subject.warn(message: 'warning message')
    end
  end

  describe '#info' do
    it 'delegates to logger info method' do
      expect(mock_logger).to receive(:info).with('info message')
      subject.info(message: 'info message')
    end
  end

  describe '#error' do
    it 'delegates to logger error method' do
      expect(mock_logger).to receive(:error).with('error message')
      subject.error(message: 'error message')
    end
  end
end
