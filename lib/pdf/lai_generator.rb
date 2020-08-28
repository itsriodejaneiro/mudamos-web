class Pdf::LaiGenerator
  def from_lai_request_payload(city_name:, is_big_city:, justification: nil)
    template = is_big_city ? 'lai_template_big_cities.pdf' : 'lai_template_small_cities.pdf'

    lai_file_template = CombinePDF.load(Rails.root.join('app', 'assets', 'docs', template))

    lai_pdf = fill_gaps lai_file_template, city_name
    justification_page = build_justification justification, city_name

    result = lai_pdf << justification_page
    result.new_page

    result.save Rails.root.join('tmp', 'result.pdf')
    justification_page.save Rails.root.join('tmp', 'justification.pdf')

    result.to_pdf
  end

  private

  def fill_gaps(template, city_name)
    template.pages[0].textbox "#{city_name}.", height: 11, width: -1, y: 715, x: 326.5, font_size: 11, text_align: :left
    template.pages[0].textbox "#{city_name};", height: 11, width: -1, y: 490, x: 148, font_size: 11, text_align: :left

    template
  end

  def build_justification(justification, city_name)
    return build_default_justification(city_name) if justification.nil? || justification.empty?

    justification = Prawn::Document.new({ page_size: "A4", page_layout: :portrait, margin: [80, 75] }) do |pdf|
      pdf.text "Justificativa do Projeto", size: 11, style: :bold, align: :left
      pdf.move_down 10
      justification.split("\n").map do |line|
        pdf.text line, size: 11, align: :left
      end
    end

    justification_result = justification.render
    CombinePDF.parse(justification_result)
  end

  def build_default_justification(city_name)
    template = CombinePDF.load(Rails.root.join('app', 'assets', 'docs', 'lai_template_default_justification.pdf'))

    template.pages[0].textbox "#{city_name}", height: 11, width: -1, y: 565, x: 232, font_size: 11, text_align: :left

    template
  end
end
