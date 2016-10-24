class String
  def is_number?
    true if Float(self) rescue false
  end

  def hex_to_rgb
    m = self.match /#(..)(..)(..)/
    return m[1].hex, m[2].hex, m[3].hex
  end
end
