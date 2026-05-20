class OrderMailer < ApplicationMailer
  ORDER_CREATED_TITLE = 'Dziękujemy za zrealizowanie zamówienia!'.freeze

  def order_created
    order = params.fetch(:order)
    service = Mails::Attachments::OrderCreatedService.new(order: order)
    files = service.call
    return handle_error(service.errors) unless service.success?

    attach_files(files)
    mail(to: order.email, subject: ORDER_CREATED_TITLE)
  end
end
