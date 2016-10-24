module ToggleableWithNotification
  extend ActiveSupport::Concern

  included do
    after_create :notify_author, if: -> {self.user_id != self.comment.user_id}
  end

  def action
    if self.is_a? Like
      'gostou do seu'
    elsif self.is_a? Dislike
      'não gostou do seu'
    elsif self.is_a? Report
      'denunciou um'
    end
  end

  def notify_name
    subject = self.comment.subject
    user = self.user

    su = SubjectUser.where(subject: subject, user: user).limit(1).first

    if su
      if su.is_anonymous
        self.user.alias_name
      else
        self.user.name
      end
    else
      "Um participante"
    end
  end

  def notify_photo
    subject = self.comment.subject
    user = self.user

    su = SubjectUser.where(subject: subject, user: user).limit(1).first

    if su
      if su.is_anonymous
        self.user.anonymous_picture_url
      else
        self.user.picture(:thumb)
      end
    else
      User.anonymous_picture_url
    end
  end

  private

    def notify_author
      send_notification
    end

    def send_notification(admin = nil)
      notif = Notification.create!(
          target_user_id: admin.nil? ? self.comment.user_id : admin.id,
          target_user_type: admin.nil? ? self.comment.user.class.to_s : admin.class.to_s,
          target_object_id: self.id,
          target_object_type: self.class.to_s,
          title: "<b>#{self.notify_name}</b> #{self.action} comentário!",
          description: "<b>#{self.notify_name}</b> #{self.action} comentário!",
          picture_url: self.notify_photo,
          view_url: "#{Rails.application.routes.url_helpers.cycle_subject_path(self.comment.subject.plugin_relation.cycle, self.comment.subject)}?comments=#{self.comment.parents_url_params}"
      )

      [InternalNotification].each do |type|
        specific_notification = type.new
        specific_notification.notification = notif

        if type == EmailNotification
          specific_notification.to_email = self.comment.user.email
          specific_notification.from_email = 'contato@mudamos.org'
          specific_notification.subject = notif.title
          specific_notification.content = notif.description
        end
        specific_notification.save!

        specific_notification.notify
      end
    end
end
