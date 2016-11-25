module MarkdownHelper
  def markdown(text, options: {}, extensions: {})
    options = {
      filter_html: true,
      no_styles: true,
      link_attributes: { rel: "nofollow", target: "_blank" },
      space_after_headers: true
    }.merge(options)

    extensions = {
      autolink:           true
    }.merge(extensions)

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end
end
