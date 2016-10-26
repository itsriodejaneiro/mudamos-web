class PetitionRepository
  include Repository

  def mock
    Petition.new body_mock, document_url_mock
  end

  private

  def document_url_mock
    "https://mudamos-its-production-images.s3.amazonaws.com/uploads/production/compilation_files/1/files/original.pdf"
  end

  def body_mock
    <<-BODY.strip_heredoc
      <div>
        <h4>Petição X</h4>

        <p>1234567890...</p>
        <p>Fim</p>
      </div>
    BODY
  end
end
