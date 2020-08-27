class LaiPdfMailer < ActionMailer::Base
  default from: "contato@mudamos.org",
          reply_to: "contato@mudamos.org"

  def send_mail(pdf_url, lai)
    @name = lai["name"]
    @pdf_url = pdf_url

    mail(
      to: lai["email"],
      bcc: "contato@mudamos.org",
      subject: "Regulamentação da Lei do Acesso à Informação de #{lai["city"]}",
      template_path: 'mailers/notification_mailer',
      template_name: 'lai_email_template'
    )
  end
end
