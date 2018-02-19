class PetitionCoverService

  attr_reader :s3

  def initialize(s3: AwsService::S3.new)
    @s3 = s3
  end

  Result = Struct.new(:files)

  def generate!(version, **options)
    image = MiniMagick::Image.open(version.document_url)
    # Order matters
    convert_options = {
      colorspace: "RGB",
      density: "150",
      depth: "3",
      quality: "50",
      resize: "2480x3508!",

      # after convertions options so we can remove the footer
      # north so we can use crop passing the 91% vh
      gravity: "north",
      # crop the info on the footer, aprox. 91% vh
      crop: "100x91%",
      # the canvas size
      extent: "2480x3508!",
      # because we will crop, we need a background canvas
      background: "white",
    }.merge(options)

    pages = image.pages.each_with_index.map do |page, i|
      converted = page.format("png", 0, convert_options)
      File.read converted.path
    end

    files = pages.each_with_index.map do |page, i|
      id = version.petition_plugin_detail_id
      page_index = i + 1
      document_name = "images/petition/#{id}/#{id}_#{page_index}.png"

      obj = s3.upload(Rails.application.secrets.buckets["petition_cover"], document_name, page, acl: "public-read")
      obj.public_url
    end

    Result.new files: files
  end

  def local!(from:, to:)
    image = MiniMagick::Image.new(from)
    convert_options = {
      colorspace: "RGB",
      density: "150",
      depth: "3",
      quality: "50",
      resize: "2480x3508!",
      gravity: "north",
      crop: "100x91%",
      extent: "2480x3508!",
      background: "white",
    }

    image.pages.each_with_index do |page, i|
      page.format("png", 0, convert_options).write("#{to}/cover_#{i}.png")
    end
  end
end
