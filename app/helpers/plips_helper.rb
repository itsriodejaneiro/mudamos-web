module PlipsHelper
  def plip_scope_description(plip_detail)
    return if plip_detail.nationwide?
    return t :national_cause if plip_detail.city.blank? && plip_detail.uf.blank?

    if plip_detail.citywide?
      "#{plip_detail.city.name}-#{plip_detail.city.uf}"
    else
      plip_detail.uf
    end
  end

  def include_plip_pin?(plip_detail)
    [PetitionPlugin::Detail::STATEWIDE_SCOPE, PetitionPlugin::Detail::CITYWIDE_SCOPE].include? plip_detail.scope_coverage
  end
end
