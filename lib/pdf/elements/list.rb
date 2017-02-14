class Pdf::Elements::List
  def self.render(pdf, element, indent: 0)
    ordered = /ol/ =~ element.name

    index = 0
    pdf.indent indent do
      element.css("> li").each do |li|
        text = li.children
          .select { |c| c.name != "ul" && c.name != "ol" }
          .map(&:to_html)
          .join("") 
          .strip

        inner_list = li.children.find {|child| child.name == "ul" || child.name == "ol" }

        pdf.text "#{ordered ? "#{index += 1}." : "•"} #{text}", inline_format: true
        if inner_list.present?
          Pdf::Elements::List.render pdf, inner_list, indent: indent + 10
        end
      end
    end
  end
end
