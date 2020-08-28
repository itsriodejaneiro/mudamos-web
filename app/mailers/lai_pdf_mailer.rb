class LaiPdfMailer < ActionMailer::Base
  default from: "contato@mudamos.org",
          reply_to: "contato@mudamos.org"

  def send_mail(city_name:, email:, name:, pdf_url:)
    @name = name
    @pdf_url = pdf_url

    mail(
      to: email,
      bcc: "contato@mudamos.org",
      subject: "Regulamentação da Lei do Acesso à Informação de #{city_name}",
      template_path: 'mailers/notification_mailer',
      template_name: 'lai_email_template'
    )
  end
end
