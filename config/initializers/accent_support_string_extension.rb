module NoAccentStrings
  def no_accent
    I18n.transliterate self # It converts chars UTF-8 to ASCII (which removes accents)
  end
end

String.include NoAccentStrings
