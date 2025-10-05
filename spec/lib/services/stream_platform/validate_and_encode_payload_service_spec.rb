require 'rails_helper'

describe Services::StreamPlatform::ValidateAndEncodePayloadService, type: :service do
  describe '#call' do
    subject { described_class.call(payload: payload, schema_name: schema_name) }

    let(:payload) { { key: 'value' } }
    let(:schema_name) { 'monitor_resources' }
    let(:mock_avro) { instance_double(AvroTurf::Messaging) }

    before do
      allow(AvroTurf::Messaging).to receive(:new).and_return(mock_avro)
    end

    context 'when encoding succeeds' do
      before do
        allow(mock_avro).to receive(:encode).with(payload, subject: schema_name, version: 1, validate: true).and_return('encoded')
      end

      it { is_expected.to eq('encoded') }
    end

    context 'when schema is missing' do
      before do
        allow(mock_avro).to receive(:encode).and_raise(AvroTurf::SchemaNotFoundError, 'not found')
      end

      it 'raises SchemaNotFoundError' do
        expect { subject }.to raise_error(Services::StreamPlatform::ValidateAndEncodePayloadService::SchemaNotFoundError)
      end
    end

    context 'when payload is invalid' do
      before do
        allow(mock_avro).to receive(:encode).and_raise(Avro::SchemaValidator::ValidationError, 'invalid')
      end

      it 'raises PayloadNotValidError' do
        expect { subject }.to raise_error(Services::StreamPlatform::ValidateAndEncodePayloadService::PayloadNotValidError)
      end
    end
  end
end
