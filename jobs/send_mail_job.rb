require "sidekiq"
require_relative "../lib/send_mail"

class SendMailJob
  include Sidekiq::Job

  def perform(user_email)
    SendMail.warning_mail(user_email)
  end
end
