module GridItemHelper
  def grid_item_title_class type, background_image = nil, blog = nil, vocabulary = nil
    if blog
      'big-title'
    elsif vocabulary
      'big-title'
    elsif background_image
      'big-title'
    else
      if type == 'single'
        'medium-title'
      elsif type == 'double-v'
        'medium-title'
      elsif type == 'double-h'
        'medium-title'
      end
    end
  end

  def grid_item_title_content object, blog = nil, vocabulary = nil
    if blog
      'Veja mais destaques do blog'
    elsif vocabulary
      'Informe-se com nosso Glossário'
    elsif object.is_a? BlogPost
      object.title
    elsif object.is_a? SocialLink
      object.description
    elsif object.is_a? Cycle
      "Vamos discutir #{object.name}?"
    end
  end

  def grid_item_link_name object
    if object.is_a? BlogPost
      'Leia mais'
    elsif object.is_a? Cycle
      'Participe!'
    else
      'Leia mais'
    end
  end

  def grid_item_link object, blog, vocabulary, cycle
    if blog
      blog_posts_path
    elsif vocabulary
      cycle_vocabularies_path(cycle)
    elsif object.is_a? BlogPost
      if object.cycle.present?
        cycle_blog_post_path(object.cycle, object)
      else
        blog_post_path(object)
      end
    elsif object.is_a? Cycle
      cycle_path(object)
    end
  end

  def grid_item_image object
    if object.is_a? BlogPost
      object.picture(:thumb)
    elsif object.is_a? Cycle
      object.picture(:thumb)
    end
  end

  def grid_item_footer_color color, background_image = nil
    if background_image
      'dark-grey'
    elsif color == 'blue'
      'blue'
    end
  end

  def grid_item_content object
    if object.is_a? BlogPost
      object.content.gsub(/(<iframe)(.+)(<\/iframe>)/, '').html_safe
    end
  end

  def grid_item_small_title object
    if object.is_a? BlogPost
      if object.cycle.present?
        object.cycle.name
      else
        'Mudamos'
      end
    end
  end
end
