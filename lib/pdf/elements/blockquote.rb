class Pdf::Elements::Blockquote
  def self.render(pdf, element)
    text_start_cursor = pdf.cursor
    pdf.indent 20 do
      pdf.text element.css("p").inner_html, inline_format: true
    end

    pdf.rectangle [0, text_start_cursor], 5, text_start_cursor - pdf.cursor
    pdf.fill_color "e5e5e5"
    pdf.fill
    pdf.fill_color "000000"
  end
end
