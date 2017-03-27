class HomeBlockRepository
  Block = Struct.new(:title, :body, :picture) do
    def blank?
      title.blank? && body.blank? && picture.blank?
    end

    def present?
      !blank?
    end
  end

  HomeBlock = Struct.new(
    :what_is,
    :solution,
    :tools,
    :mobilization
  )

  def blocks
    HomeBlock.new(
      what_is,
      solution,
      tools,
      mobilization
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
