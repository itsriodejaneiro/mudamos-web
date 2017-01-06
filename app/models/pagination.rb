class Pagination
  # @!attribute [r] page
  #   @return [Integer]
  attr_reader :page

  # @!attribute [r] limit
  #   @return [Integer]
  attr_reader :limit

  # @!attribute [r] items
  #   @return [Array]
  attr_reader :items

  # @!attribute [r] has_next
  #   @return [Boolean]
  attr_reader :has_next

  # @param items [Array]
  # @param page [Integer]
  # @param limit [Integer]
  # @param has_next [Boolean]
  # @param representation [#represent]
  def initialize(items:, page:, limit:, has_next:)
    @items = items
    @page = page
    @limit = limit
    @has_next = has_next
  end
end
