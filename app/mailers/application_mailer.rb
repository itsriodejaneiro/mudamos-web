class ApplicationMailer < ActionMailer::Base
  default from: "contato@mudamos.org",
          reply_to: "contato@mudamos.org"

  layout 'mailer'
end
