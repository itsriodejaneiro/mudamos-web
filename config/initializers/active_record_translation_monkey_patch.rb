class ActiveRecord::Base
  def t(attr)
    c = self.class.to_s.underscore
    if attr.first == "."
      I18n.t("activerecord.errors.models.#{c}.attributes#{attr}")
    else
      I18n.t(attr)
    end
  end
end
