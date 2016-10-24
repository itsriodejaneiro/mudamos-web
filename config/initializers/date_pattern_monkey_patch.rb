Time::DATE_FORMATS[:default] = '%Y-%m-%dT%H:%M:%S%z'

class ActiveSupport::TimeWithZone
  def to_short_date(options = {})
    I18n.l(self, format: '%d %b %Y')
  end

  def to_short_time(options = {})
    I18n.l(self, format: '%H:%M')
  end
end

class Date
  def to_short_date(options = {})
    I18n.l(self, format: '%d %b %Y')
  end

  def to_short_time(options = {})
    I18n.l(self, format: '%H:%M')
  end
end

class Time
  def to_short_date(options = {})
    I18n.l(self, format: '%d %b %Y')
  end

  def to_short_time(options = {})
    I18n.l(self, format: '%H:%M')
  end
end
