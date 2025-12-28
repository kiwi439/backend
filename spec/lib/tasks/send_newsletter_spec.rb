require 'rails_helper'

describe 'send_newsletter rake task' do
  subject { Rake::Task['send_newsletter'].invoke }

  let(:mailer_instance) { instance_double(NewsletterMailer) }
  let(:message_delivery) { instance_double(ActionMailer::MessageDelivery) }
  let(:newsletter1) { Newsletter.find_by(email: 'user1@example.com') }
  let(:newsletter2) { Newsletter.find_by(email: 'user2@example.com') }

  before do
    Rake.application.rake_require 'tasks/send_newsletter'
    Rake.application.load_rakefile
    Rake::Task['send_newsletter'].reenable

    create(:newsletter, email: 'user1@example.com')
    create(:newsletter, email: 'user2@example.com')

    allow(NewsletterMailer).to receive(:with).and_return(mailer_instance)
    allow(mailer_instance).to receive(:send_newsletter).and_return(message_delivery)
    allow(message_delivery).to receive(:deliver_later)
  end

  it 'sends newsletter to all users' do
    expect(NewsletterMailer).to receive(:with).with(newsletter: newsletter1).and_return(mailer_instance)
    expect(NewsletterMailer).to receive(:with).with(newsletter: newsletter2).and_return(mailer_instance)

    expect { subject }.not_to raise_error
  end
end
