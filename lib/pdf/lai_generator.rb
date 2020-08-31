class Pdf::LaiGenerator
  def generate(city_name:, is_big_city:, justification: nil)
    lai_doc = build_lai_doc city_name, is_big_city
    justification_page = build_justification justification, city_name

    result = lai_doc << justification_page
    result.new_page [0, 0, 595, 842] # A4 mediabox

    justification_page.save Rails.root.join('tmp', 'justification.pdf')
    result.save Rails.root.join('tmp', 'result.pdf')

    result.to_pdf
  end

  private

  def build_lai_doc(city_name, is_big_city)
    template_file = is_big_city ? 'lai_template_big_cities.pdf' : 'lai_template_small_cities.pdf'
    lai_with_gaps_pdf = CombinePDF.load(Rails.root.join('app', 'assets', 'docs', template_file))

    lai_with_blocks = Prawn::Document.new({ page_size: "A4", page_layout: :portrait, margin: [80, 75] }) do |pdf|
      pdf.draw_text "#{city_name}.", size: 11, at: [278, 635.5]
      pdf.draw_text "#{city_name}.", size: 11, at: [118, 410.5]
    end
    lai_with_blocks_pdf = CombinePDF.parse(lai_with_blocks.render)

    lai_with_gaps_pdf.pages[0] << lai_with_blocks_pdf.pages[0]
    lai_with_gaps_pdf
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

    CombinePDF.parse(justification.render)
  end

  def build_default_justification(city_name)
    justification_with_gaps_pdf = CombinePDF.load(Rails.root.join('app', 'assets', 'docs', 'lai_template_default_justification.pdf'))

    justification_with_blocks = Prawn::Document.new({ page_size: "A4", page_layout: :portrait, margin: [80, 75] }) do |pdf|
      pdf.draw_text city_name, size: 11, at: [194, 485]
    end
    justification_with_blocks_pdf = CombinePDF.parse(justification_with_blocks.render)

    justification_with_gaps_pdf.pages[0] << justification_with_blocks_pdf.pages[0]
    justification_with_gaps_pdf
  end
end
