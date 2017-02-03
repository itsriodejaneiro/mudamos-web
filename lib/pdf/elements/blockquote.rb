class Pdf::Elements::Blockquote
  def self.render(pdf, element)
    # TODO we should render a gray background behind this
    pdf.text element.css("p").inner_html, inline_format: true
  end
end
