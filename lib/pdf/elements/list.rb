class Pdf::Elements::List
  def self.render(pdf, element, indent: 0)
    ordered = /ol/ =~ element.name

    index = 0
    pdf.indent indent do
      element.css("> li").each do |li|
        inner_list = li.children.css("ul,ol")

        if inner_list.length > 0
          Pdf::Elements::List.render pdf, inner_list.first, indent: indent + 20
        else
          pdf.text "#{ordered ? "#{index += 1}." : "•"} #{li.inner_html}", inline_format: true
        end
      end
    end
  end
end
