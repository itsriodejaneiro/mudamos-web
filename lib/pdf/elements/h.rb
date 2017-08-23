class Pdf::Elements::H
  def self.render(pdf, element)
    size = /h([1-6])/.match(element.name)[1].to_i

    font_size = 32 - (size * 2)

    pdf.text element.inner_html, inline_format: true, style: :bold, size: font_size
  end
end
