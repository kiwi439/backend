module Users
  module Registration
    class ValidateAvatarService
      extend Utils::CallableObject

      FUNCTION_LAMBDA_NAME = 'ValidateFaceInsideAvatar'.freeze

      def initialize(avatar_as_base64:)
        @avatar_as_string = Base64.encode64(avatar_as_base64)
      end

      def call
        response = ::Services::Aws::LambdaService.call(function_name: FUNCTION_LAMBDA_NAME, payload: { avatar_as_string: @avatar_as_string })
        is_avatar_valid = response.fetch(:body_response)
        is_avatar_valid
      rescue Services::Aws::LambdaService::PerformingLambdaFunctionError => e
        false
      end
    end
  end
end
