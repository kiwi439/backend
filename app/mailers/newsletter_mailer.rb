class NewsletterMailer < ApplicationMailer
  SEND_NEWSLETTER_TITLE = 'Cotygodniowy newsletter!'.freeze

  def send_newsletter
    @newsletter = params.fetch(:newsletter)
    service = Mails::Attachments::SendNewsletterService.new
    files = service.call
    return handle_error(service.errors) unless service.success?

    attach_files(files)
    mail(to: @newsletter.email, subject: SEND_NEWSLETTER_TITLE)
  end
end
