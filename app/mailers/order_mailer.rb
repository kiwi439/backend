class OrderMailer < ApplicationMailer
  ORDER_CREATED_TITLE = 'Dziękujemy za zrealizowanie zamówienia!'.freeze

  def order_created
    order = params.fetch(:order)
    service = Mails::Order::GenerateAtachmentsForOrderCreatedService.new(order: order)
    files = service.call
    return handle_error(service.errors) if service.errors.any?

    attach_files(files)
    mail(to: order.email, subject: ORDER_CREATED_TITLE)
  end

  private

  def handle_error(errors)
    Rollbar.error(errors.join(', '))
    nil
  end
end
