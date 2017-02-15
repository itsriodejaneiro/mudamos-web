module Api
  module EntitiesHelpers
    Grape::Entity.format_with :iso_date do |date|
      date.to_date.iso8601 if date
    end

    Grape::Entity.format_with :iso_date_time do |date|
      date.iso8601 if date
    end
  end
end
