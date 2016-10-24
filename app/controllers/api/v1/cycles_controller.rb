class Api::V1::CyclesController < Api::V1::ApplicationController
  def index
    self.collection = query_searched_collection
    self.collection = related_included_collection
    self.collection = paginated_collection

    status = 200

    if self.collection.empty?
      status = 204
    end

    hash = {}

    ['logo_png', 'home_header', 'home_sub_title', 'home_title1', 'home_text1', 'home_title2', 'home_text2', 'home_title3', 'home_text3'].each do |k|
      s = Setting.find_by_key(k)

      if s.value.present?
        hash[k] = s.value.as_json
      else
        hash[k] = s.picture.as_json 
      end
    end

    hash[model_instance_variable_plural] = json_collection

    render status: status, json: hash
  end
end
