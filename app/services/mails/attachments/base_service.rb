# frozen_string_literal: true

module Mails
  module Attachments
    class BaseService
      include ServiceStatus

      def call
        build_attachments
        attachments
      rescue StandardError => e
        errors << e.message
        []
      end

      private

      def attachments
        @attachments ||= []
      end

      def build_attachments
        raise NotImplementedError, "#{self.class} must implement #build_attachments"
      end
    end
  end
end
