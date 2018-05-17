module PetitionHelper
  def translate_dynamic_link_metrics(value)
    I18n.t("activerecord.attributes.petition_plugin/detail.metrics.#{value.downcase}")
  end
end
