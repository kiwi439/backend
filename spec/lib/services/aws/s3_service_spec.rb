require 'rails_helper'

describe Services::Aws::S3Service, type: :service do
  subject { described_class.new }

  let(:mock_client) { instance_double(Aws::S3::Client) }
  let(:bucket) { Rails.configuration.aws_bucket }

  before do
    allow(Aws::S3::Client).to receive(:new).and_return(mock_client)
  end

  describe '#get_object' do
    it 'delegates to AWS client with bucket and key' do
      expect(mock_client).to receive(:get_object).with(bucket: bucket, key: 'path/to/file')
      subject.get_object(key: 'path/to/file')
    end
  end

  describe '#list_objects' do
    it 'delegates to AWS client with bucket and prefix' do
      expect(mock_client).to receive(:list_objects).with(bucket: bucket, prefix: 'dir/')
      subject.list_objects(directory_name: 'dir/')
    end
  end

  describe '#put_object' do
    it 'delegates to AWS client with bucket, key and body' do
      expect(mock_client).to receive(:put_object).with(bucket: bucket, key: 'path/new', body: 'data')
      subject.put_object(key: 'path/new', body: 'data')
    end
  end

  describe '#delete_object' do
    it 'delegates to AWS client with bucket and key' do
      expect(mock_client).to receive(:delete_object).with(bucket: bucket, key: 'obsolete')
      subject.delete_object(key: 'obsolete')
    end
  end

  context 'when a custom bucket is provided' do
    subject { described_class.new(bucket: custom_bucket) }

    let(:custom_bucket) { 'another-bucket' }

    it 'uses the custom bucket for client calls' do
      expect(mock_client).to receive(:get_object).with(bucket: custom_bucket, key: 'file')
      subject.get_object(key: 'file')
    end
  end
end


