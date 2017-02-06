class Pdf::Elements::Blockquote
  def self.render(pdf, element)
    pdf.indent 20 do
      pdf.text element.css("p").inner_html, inline_format: true
    end
  end
end
