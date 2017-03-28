class HomeBlockRepository
  Block = Struct.new(:title, :body, :picture, :video_url) do
    def blank?
      title.blank? && body.blank? && picture.blank? && video_url.blank?
    end

    def present?
      !blank?
    end
  end

  HomeBlock = Struct.new(
    :what_is,
    :solution,
    :tools,
    :mobilization,
    :main_block
  )

  def blocks
    HomeBlock.new(
      what_is,
      solution,
      tools,
      mobilization,
      main_block
    )
  end

  def main_block
    Block.new(
      Setting.find_by_key("home_sub_title").try(:value),
      nil,
      Setting.find_by_key("home_picture").try(:picture),
      Setting.find_by_key("home_main_video").try(:video_url)
    )
  end

  def what_is
    Block.new(
      Setting.find_by_key("home_block_1_title").try(:value),
      Setting.find_by_key("home_block_1_body").try(:value),
      Setting.find_by_key("home_block_1_icon").try(:picture)
    )
  end

  def solution
    Block.new(
      Setting.find_by_key("home_block_2_title").try(:value),
      Setting.find_by_key("home_block_2_body").try(:value),
      Setting.find_by_key("home_block_2_icon").try(:picture)
    )
  end

  def tools
    blocks = (3..7).each.map do |index|
      Block.new(
        Setting.find_by_key("home_block_#{index}_title").try(:value),
        Setting.find_by_key("home_block_#{index}_body").try(:value),
        Setting.find_by_key("home_block_#{index}_icon").try(:picture)
      )
    end

    blocks.reject(&:blank?)
  end

  def mobilization
    Block.new(
      Setting.find_by_key("home_block_8_title").try(:value),
      Setting.find_by_key("home_block_8_body").try(:value),
      Setting.find_by_key("home_block_8_icon").try(:picture)
    )
  end
end
