module UserInput
  def bool(value)
    case value
    when true, /\Atrue\z/i then true
    else
      false
    end
  end
end
