# frozen_string_literal: true

describe Mails::Attachments::SendNewsletterService, type: :service do
  describe '#call' do
    subject { service.call }

    let(:service) { described_class.new }
    let(:s3_service) do
      string_io_instance = instance_double(StringIO, string: 'file_as_string')
      s3_object_instance = instance_double(Aws::S3::Types::GetObjectOutput, body: string_io_instance)
      instance_double(Services::Aws::S3Service, get_object: s3_object_instance)
    end

    before do
      allow(Services::Aws::S3Service).to receive(:new).and_return(s3_service)
    end

    context 'success path' do
      it 'is successful' do
        subject
        expect(service.success?).to be(true)
      end

      it 'returns newsletter presentation as attachment' do
        expect(subject).to eq([{ file_name: 'Prezentacja budowlana.pptx', content: 'file_as_string' }])
      end
    end

    context 'failure path' do
      before do
        allow(s3_service).to receive(:get_object).and_raise(StandardError, 'S3 upload failed')
      end

      it 'is not successful' do
        subject
        expect(service.success?).to be(false)
      end

      it 'returns empty attachments' do
        expect(subject).to eq([])
      end

      it 'records error message' do
        subject
        expect(service.errors.first).to eq('S3 upload failed')
      end
    end
  end
end
