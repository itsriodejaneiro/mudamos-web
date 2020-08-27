module UserInput
  def bool(value)
    case value
    when true, /\Atrue\z/i then true
    else
      false
    end
  end

  def clean_up_name(value)
    value.squeeze.strip.downcase.no_accent
  end
end
