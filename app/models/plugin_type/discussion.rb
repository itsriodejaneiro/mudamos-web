class PluginType::Discussion
  def can_user_interact?(user)
    user.email.present? &&
    user.name.present? &&
    user.birthday.present? &&
    user.gender.present? &&
    user.state.present? &&
    user.city.present? &&
    user.profile.present? &&
    (user.profile.children.length == 0 || user.sub_profile.present?)
  end
end
