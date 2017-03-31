module CycleHelper
  def cycle_background(cycle_color)
    "#{cycle_color} linear-gradient(180deg, rgba(255, 255, 255, 0) 0%, rgba(0, 0, 0, 0.14) 100%)"
  end

  def next_block_link
    content_tag :div, class: "next" do
      content_tag :a, href: "#", class: "block-scroll-to" do
        concat image_tag("arrow_down_white.svg", class: "white")
        concat image_tag("arrow_down_purple.svg", class: "purple")
      end
    end
  end
end
