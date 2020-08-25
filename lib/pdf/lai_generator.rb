class Pdf::LaiGenerator
  include MarkdownHelper

  def from_lai_request_payload(lai, is_big_city)
    template = is_big_city ? 'lai_template_big_cities.pdf' : 'lai_template_small_cities.pdf'

    lai_file_template = CombinePDF.load(Rails.root.join('app', 'assets', 'docs', template))

    result = fill_gaps lai_file_template, lai

    # pdf.render_file("/tmp/rofl.pdf")
    # pdf_result = pdf.render
    # result = CombinePDF.parse(pdf_result) << CombinePDF.load("/Users/guimello/Downloads/table.pdf")
    # pdf_result.save Rails.root.join('tmb', 'output.pdf')

    result.to_pdf
  end

  private

  # def setup(pdf)
  #   font_path = Rails.root.join("app", "assets", "fonts")
  #   pdf.font_families.update(
  #     "Roboto" => {
  #       normal: "#{font_path.to_s}/Roboto-Light.ttf",
  #       italic: "#{font_path.to_s}/Roboto-LightItalic.ttf",
  #       bold: "#{font_path.to_s}/Roboto-Bold.ttf",
  #       bold_italic: "#{font_path.to_s}/Roboto-BoldItalic.ttf",
  #     }
  #   )
  #
  #   pdf.font "Roboto"
  # end

  def fill_gaps(template, lai)
    template.pages[0].textbox lai["name"], height: 10, y: 50, x: 0, text_align: :left

    template
    # html_document = Nokogiri::HTML(markdown(text))
    # pdf.span(pdf.cursor, position: :left) do
      # pdf.bounding_box([20, pdf.cursor - 30], width: 505) do
        # html_document.css("body").children.each do |element|

          # case element.name
          # when "p" then Pdf::Elements::P.render pdf, element
          # when "blockquote" then Pdf::Elements::Blockquote.render pdf, element
          # when /h[1-6]/ then Pdf::Elements::H.render pdf, element
          # when /ul|ol/ then Pdf::Elements::List.render pdf, element
          # end

          # pdf.move_down 10
        # end
      # end
    # end
  end
end
