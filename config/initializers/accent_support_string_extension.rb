module NoAccentStrings
  def no_accent
    self.
        gsub(/\xC3\xA0/,  'a').     # à => a
        gsub(/\xC3\xA1/,  'a').     # á => a
        gsub(/\xC3\xA2/,  'a').     # â => a
        gsub(/\xC3\xA3/,  'a').     # ã => a
        gsub(/\xC3\xA9/,  'e').     # é => e
        gsub(/\xC3\xAA/,  'e').     # ê => e
        gsub(/\xC3\xAD/,  'i').     # í => i
        gsub(/\xC3\xB3/,  'o').     # ó => o
        gsub(/\xC3\xB4/,  'o').     # ô => o
        gsub(/\xC3\xB5/,  'o').     # õ => o
        gsub(/\xC3\xBA/,  'u').     # ú => u
        gsub(/\xC3\xBC/,  'u').     # ü => u
        gsub(/\xC3\xA7/,  'c').     # ç => c
        gsub(/\xC3\x80/,  'A').     # À => A
        gsub(/\xC3\x81/,  'A').     # Á => A
        gsub(/\xC3\x82/,  'A').     # Â => A
        gsub(/\xC3\x83/,  'A').     # Ã => A
        gsub(/\xC3\x89/,  'E').     # É => E
        gsub(/\xC3\x8A/,  'E').     # Ê => E
        gsub(/\xC3\x8D/,  'I').     # Í => I
        gsub(/\xC3\x93/,  'O').     # Ó => O
        gsub(/\xC3\x94/,  'O').     # Ô => O
        gsub(/\xC3\x95/,  'O').     # Õ => O
        gsub(/\xC3\x9A/,  'U').     # Ú => U
        gsub(/\xC3\x9C/,  'U').     # Ü => U
        gsub(/\xC3\x87/,  'C')      # Ç => C
  end
end

String.include NoAccentStrings
