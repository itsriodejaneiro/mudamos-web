class LaiPdfRepository
  include Repository

  def find(id)
    LaiPdf.find_by_id id
  end
end
