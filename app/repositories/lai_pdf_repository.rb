class LaiPdfRepository
  include Repository
  include UserInput

  def find(id)
    LaiPdf.find_by_id id
  end
end
