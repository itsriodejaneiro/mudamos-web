# require "mandrill"

class NotificationMailer < ActionMailer::Base
  default from: "contato@mudamos.org",
          reply_to: "contato@mudamos.org"

  def send_notification_email email_notification
    @email_notification = email_notification
    @notification = @email_notification.notification

    @target_user = @notification ? @notification.target_user : nil

    if Rails.env.development?
      email = 'ariel@inventosdigitais.com.br'
    else
      email = email_notification.to_email
    end

    subject = email_notification.subject
    content = email_notification.content

    send_mail(email, subject, content)
  end

  private

    def send_mail(email, subject, body)
      mail(
        to: email,
        subject: subject,
        template_path: 'mailers/notification_mailer',
        template_name: 'send_notification_email'
      )
    end

  #   def mandrill_template(template_name, attributes)
  #     mandrill = Mandrill::API.new(ENV["SMTP_PASSWORD"])

  #     merge_vars = attributes.map do |key, value|
  #       { name: key, content: value }
  #     end

  #     mandrill.templates.render(template_name, [], merge_vars)["html"]
  #   end

end
