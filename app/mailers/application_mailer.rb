class ApplicationMailer < ActionMailer::Base
  default from: 'Sklep budowlany Budoman'
  layout 'mailer'

  private

  def attach_files(files)
    files.each do |file|
      attachments[file[:file_name]] = file[:content]
    end
  end
end
