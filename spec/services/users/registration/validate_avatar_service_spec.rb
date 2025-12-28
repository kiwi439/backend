require 'rails_helper'

describe Users::Registration::ValidateAvatarService, type: :service do
  describe '#call' do
    subject { described_class.call(avatar_as_base64: avatar_as_base64) }

    let(:avatar_as_base64) { 'decoded_base64_image_data' }

    context 'when Lambda detects a face in avatar' do
      let(:lambda_response) { { body_response: true } }

      before do
        allow(Services::Aws::LambdaService).to receive(:call).and_return(lambda_response)
      end

      it 'calls Lambda service with correct parameters' do
        expect(Services::Aws::LambdaService).to receive(:call).with(function_name: 'ValidateFaceInsideAvatar', payload: { avatar_as_string: Base64.encode64(avatar_as_base64) })

        subject
      end

      it 'returns true when face is detected' do
        expect(subject).to be true
      end
    end

    context 'when Lambda does not detect a face in avatar' do
      let(:lambda_response) { { body_response: false } }

      before do
        allow(Services::Aws::LambdaService).to receive(:call).and_return(lambda_response)
      end

      it 'calls Lambda service with correct parameters' do
        expect(Services::Aws::LambdaService).to receive(:call).with(function_name: 'ValidateFaceInsideAvatar', payload: { avatar_as_string: Base64.encode64(avatar_as_base64) })

        subject
      end

      it 'returns false when no face is detected' do
        expect(subject).to be false
      end
    end

    context 'when Lambda service raises PerformingLambdaFunctionError' do
      let(:error) { Services::Aws::LambdaService::PerformingLambdaFunctionError.new(message: 'Lambda function failed') }

      before do
        allow(Services::Aws::LambdaService).to receive(:call).and_raise(error)
      end

      it 'returns false on error' do
        expect(subject).to be false
      end
    end
  end
end
