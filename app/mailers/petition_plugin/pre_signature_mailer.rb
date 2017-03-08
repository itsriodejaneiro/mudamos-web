module PetitionPlugin
  class PreSignatureMailer < ApplicationMailer
    layout false

    def just_signed(user:, phase:, user_password: nil)
      @user = user
      @phase = phase
      @user_password = user_password

      mail to: @user.email, subject: I18n.t(:subject, scope: %i(mailer pre_signature))
    end

    private

    helper do
      def android_store_page
        Rails.application.secrets.mobile_app["store_page"]["android"] || "#"
      end

      def apple_store_page
        Rails.application.secrets.mobile_app["store_page"]["ios"] || "#"
      end
    end
  end
end
