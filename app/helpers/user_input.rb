module UserInput
  def bool(value)
    case value
    when true, /\Atrue\z/i then true
    else
      false
    end
  end

  def clean_up_name(value)
    case value.is_a?
    when String, value.squeeze.strip.downcase.no_accent
    else
      value
    end
  end
end
