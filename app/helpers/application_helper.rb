module ApplicationHelper
  include GridItemHelper

  def can_user_interact_with_plugin?(plugin_type_name, user)
    plugin_type = PluginTypeRepository.new.get_plugin_type(plugin_type_name)
    plugin_type.can_user_interact? user
  end

  def blog_post_dependent_path blog_post
    if blog_post.cycle
      cycle_blog_post_path(blog_post.cycle, blog_post)
    else
      blog_post_path(blog_post)
    end
  end

  def input f, attribute, options = {}
    m = f.object.class.to_s.underscore

    input_options = {
      autocomplete: :off,
      html: { value: options[:value] || f.object.send(attribute) },
      value: options[:value] || f.object.send(attribute)
    }

    if options[:class]
      input_options.merge!(class: options[:class])
    end

    if options[:style]
      input_options.merge!(style: options[:style])
    end

    if options[:checked]
      input_options.merge!(checked: options[:checked])
    end

    if options[:input_id]
      input_options.merge!(id: options[:input_id])
    end

    label_options = {}
    if options[:label_for]
      label_options[:for] = options[:label_for]
    end

    if options[:label_style]
      label_options[:style] = options[:label_style]
    end

    content_tag :li, class: "#{options[:as]} #{attribute} input float-label-input #{options[:wrapper_class]}", style: "#{options[:wrapper_style]}", id: (options[:wrapper_id] || "#{m}_attribute_input") do
      # concat(f.input attribute, wrapper: false, label: false)
      concat(f.send(input_type(options[:as]), attribute, input_options))
      unless options[:label] == false
        concat(f.label attribute, options[:label], label_options)
      end
    end
  end

  def input_type as
    case as
    when :password
      'password_field'
    when :number
      'number_field'
    when :check_box
      'check_box'
    else
      'text_field'
    end
  end

  def color_as_rgba(color, alpha)
    r, g, b = color.scan(/[a-fA-F0-9]{2}/).map { |color| color.to_i(16) }
    "rgba(#{r}, #{g}, #{b}, #{alpha})"
  end

  def you_tube_link_to(video_id)
    link_to video_id, "https://www.youtube.com/watch?v=#{video_id}", target: "_blank" if video_id.present?
  end

  def you_tube_embed(video_id)
    return if video_id.blank?

    source = "https://www.youtube.com/embed/#{video_id}?&modestbranding=1&showinfo=0&iv_load_policy=3&rel=0"

    content_tag :iframe, nil,
      src: source,
      frameborder: 0,
      allowfullscreen: 1,
      class: "you-tube-iframe"
  end

  def mudamos_logos_urls
    [
      "https://s3-sa-east-1.amazonaws.com/mudamos-images/images/home-lead-mudamos-logo-dark.svg",
      "https://s3-sa-east-1.amazonaws.com/mudamos-images/images/home-lead-mudamos-logo.svg"
    ]
  end

  def mobile_app_ios_store_url
    Rails.application.secrets.mobile_app["store_page"]["ios"]
  end

  def mobile_app_android_store_url
    Rails.application.secrets.mobile_app["store_page"]["android"]
  end
end
