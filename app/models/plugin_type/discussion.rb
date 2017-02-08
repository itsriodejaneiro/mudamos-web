class PluginType::Discussion
  def can_user_interact?(user)
    user.email.present? &&
    user.name.present? &&
    user.birthday.present? &&
    user.gender.present? &&
    user.profile.present?
  end
end
