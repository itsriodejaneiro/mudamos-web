class Pdf::Generator

  include MarkdownHelper

  def from_markdown(text)
    pdf = Prawn::Document.new

    setup pdf
    
    pdf.repeat(:all) do
      render_header pdf
      render_border pdf
      render_footer pdf
    end

    render_body pdf, text

    pdf.render
  end

  private

  def setup(pdf)
    font_path = Rails.root.join("app", "assets", "fonts")
    pdf.font_families.update(
      "Roboto" => {
        normal: "#{font_path.to_s}/Roboto-Light.ttf",
        italic: "#{font_path.to_s}/Roboto-LightItalic.ttf",
        bold: "#{font_path.to_s}/Roboto-Bold.ttf",
        bold_italic: "#{font_path.to_s}/Roboto-BoldItalic.ttf",
      }
    )

    pdf.font "Roboto"
  end

  def render_header(pdf)
    y_position = pdf.cursor
    pdf.text_box "Projeto de iniciativa popular", size: 12, style: :bold, at: [70, pdf.cursor]
    pdf.move_down 15
    pdf.text_box "Ficha limpa", size: 12, style: :bold, at: [70, pdf.cursor]

    pdf.move_down 30
    pdf.text_box "Ajude a acabar com a corrupção eleitoral no Brasil", size: 10, at: [70, pdf.cursor]

    pdf.move_down 30

    pdf.image Rails.root.join("app", "assets", "images", "logo_pdf.png").to_s, width: 70, height: 70, at: [0, y_position + 5]
  end

  def render_border(pdf)
    pdf.rectangle [0, pdf.cursor], 540, 585 
    pdf.stroke
  end

  def render_footer(pdf)
    image_x = 230
    image_y = 75 

    pdf.rectangle [image_x - 10, image_y + 5], 90, 40 
    pdf.fill_color "ffffff"
    pdf.fill
    pdf.fill_color "000000"

    pdf.image Rails.root.join("app", "assets", "images", "logo_pdf_horizontal.png").to_s, width: 70, at: [image_x, image_y]
    pdf.text_box "Esse é um arquivo assinado digitalmente.", size: 12, at: [image_x - 80, image_y - 45]
    pdf.text_box "Você pode verificar sua autenticidade acessando <u><link href='https://www.mudamos.org/'>https://www.mudamos.org/</link></u>", size: 12, at: [image_x - 180, image_y - 60], inline_format: true
  end

  def render_body(pdf, text)
    html_document = Nokogiri::HTML(markdown(text))
    pdf.span(pdf.cursor, position: :left) do
      pdf.bounding_box([20, pdf.cursor - 30], width: 505, height: 530) do
        html_document.css("body").children.each do |element|
          
          case element.name
          when "p" then Pdf::Elements::P.render pdf, element
          when "blockquote" then Pdf::Elements::Blockquote.render pdf, element
          when /h[1-6]/ then Pdf::Elements::H.render pdf, element
          when /ul|ol/ then Pdf::Elements::List.render pdf, element
          end

          pdf.move_down 5 
        end
      end
    end
  end
end
