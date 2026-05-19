# frozen_string_literal: true

module Mails
  module Attachments
    class SendNewsletterService < BaseService
      private

      def build_attachments
        attachments << { file_name: 'Prezentacja budowlana.pptx', content: construction_presentation }
      end

      def construction_presentation
        object = ::Services::Aws::S3Service.new.get_object(key: 'documents/prezentacja-budowlana.pptx')
        object.body.string
      end
    end
  end
end
