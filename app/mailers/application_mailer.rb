class ApplicationMailer < ActionMailer::Base
  default from: ENV["SENDER_EMAIL_DEFAULT"]
  layout "mailer"
end
