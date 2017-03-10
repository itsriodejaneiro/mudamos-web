class Pdf::Elements::P
  def self.render(pdf, element)
    pdf.text element.inner_html, inline_format: true
  end
end
