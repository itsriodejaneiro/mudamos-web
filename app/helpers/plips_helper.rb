module PlipsHelper
  # def display_scope_coverage(scope_coverage)
  #   dic = { citywide: "Municipal", statewide: "Estadual", nationwide: "Federal" }
  #   dic[scope_coverage.to_sym]
  # end
  
  def scope_name(plip_detail)  
    if plip_detail.citywide?
      "#{plip_detail.city.name} - #{plip_detail.city.uf}"   
    elsif plip_detail.statewide?     
      plip_detail.uf  
    end  
  end
end
