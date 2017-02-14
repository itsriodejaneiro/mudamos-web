class PluginType::Petition
  def can_user_interact?(user)
    user.email.present? &&
    user.name.present? &&
    user.birthday.present?
  end
end
