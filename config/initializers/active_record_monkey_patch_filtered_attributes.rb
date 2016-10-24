class ActiveRecord::Base
  def as_json filter = []
    self.filtered_attributes
  end

  def filtered_attributes filter = []
    h = {}

    self.attributes_to_filter(filter).each do |k|
      h[k] = self.send(k.to_sym).as_json
    end

    h
  end

  def attributes_to_filter filter = []
    if filter.blank?
      all_attributes
    else
      f = filter.split(',')

      f
    end
  end

  def all_attributes
    self.attributes.keys
  end
end
