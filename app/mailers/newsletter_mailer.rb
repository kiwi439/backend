class NewsletterMailer < ApplicationMailer
  SEND_NEWSLETTER_TITLE = 'Cotygodniowy newsletter!'.freeze

  def send_newsletter
    @newsletter = params.fetch(:newsletter)
    service = Mails::Newsletter::GenerateAtachmentsForSendNewsletterService.new
    files = service.call

    attach_files(files)
    mail(to: @newsletter.email, subject: SEND_NEWSLETTER_TITLE)
  end
end
