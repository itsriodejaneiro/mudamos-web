class Search
  def self.find value
    h = Hash.new

    cycles = Cycle.cycle_search(value)
    h[:cycles] = cycles unless cycles.empty?

    subjects = Subject.subject_search(value)
    h[:subjects] = subjects unless subjects.empty?

    blog_posts = BlogPost.blog_post_search(value)
    h[:blog_posts] = blog_posts unless blog_posts.empty?

    # users = User.user_search(User.encrypt_name(value))
    # h[:users] = users unless users.empty?

    vocabularies = Vocabulary.vocabulary_search(value)
    h[:vocabularies] = vocabularies unless vocabularies.empty?

    materials = Material.material_search(value)
    h[:materials] = materials unless materials.empty?

    comments = Comment.comments_search(value)
    # comments = Comment.where(id: (comments.pluck(:id) + comments_users.pluck(:id)))

    h[:comments] = comments unless comments.empty?

    h
  end

  def self.translate_key k
    case k
    when :users
      'Usuários'
    when :cycles
      'Temas'
    when :subjects
      'Assuntos'
    when :blog_posts
      'Blog'
    when :vocabularies
      'Glossário'
    when :materials
      'Biblioteca'
    when :comments
      'Comentários'
    end
  end
end
