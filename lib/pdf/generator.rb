class Pdf::Generator

  include MarkdownHelper

  def from_markdown(text)
    pdf = Prawn::Document.new
    html_document = Nokogiri::HTML(markdown(text))

    font_path = "/home/erick/projects/tagview/mudamos-web/app/assets/fonts"
    pdf.font_families.update(
      "Roboto" => {
        normal: "#{font_path}/Roboto-Light.ttf",
        italic: "#{font_path}/Roboto-LightItalic.ttf",
        bold: "#{font_path}/Roboto-Bold.ttf",
      }
    )

    pdf.font "Roboto"

    pdf.repeat(:all) do
      y_position = pdf.cursor
      pdf.text_box "Projeto de iniciativa popular", size: 12, style: :bold, at: [70, pdf.cursor]
      pdf.move_down 15
      pdf.text_box "Ficha limpa", size: 12, style: :bold, at: [70, pdf.cursor]

      pdf.move_down 30
      pdf.text_box "Ajude a acabar com a corrupção eleitoral no Brasil", size: 10, at: [70, pdf.cursor]

      pdf.move_down 30

      pdf.image "/home/erick/projects/tagview/mudamos-web/app/assets/images/logo_pdf.png", width: 70, height: 70, at: [0, y_position + 5]

      pdf.rectangle [0, pdf.cursor], 540, 585 
      pdf.stroke

      image_x = 230
      image_y = 75 

      pdf.rectangle [image_x - 10, image_y + 5], 90, 40 
      pdf.fill_color "ffffff"
      pdf.fill
      pdf.fill_color "000000"

      pdf.image "/home/erick/projects/tagview/mudamos-web/app/assets/images/logo_pdf_horizontal.png", width: 70, at: [image_x, image_y]
      pdf.text_box "Esse é um arquivo assinado digitalmente.", size: 12, at: [image_x - 80, image_y - 45]
      pdf.text_box "Você pode verificar sua autenticidade acessando <u><link href='https://www.mudamos.org/'>https://www.mudamos.org/</link></u>", size: 12, at: [image_x - 180, image_y - 60], inline_format: true
    end

    pdf.span(pdf.cursor, position: :left) do
      pdf.bounding_box([20, pdf.cursor - 30], width: 505, height: 530) do
        html_document.css("body").children.each do |element|
          if element.name == "p"   
            Pdf::Elements::P.render pdf, element
          elsif /h[1-6]/ =~ element.name
            Pdf::Elements::H.render pdf, element
          elsif element.name == "blockquote"
            Pdf::Elements::Blockquote.render pdf, element
          elsif /ul|ol/ =~ element.name
            Pdf::Elements::List.render pdf, element
          end
          pdf.move_down 5 
        end
      end
    end

    pdf.render_file "/tmp/test2.pdf"
  end
end
