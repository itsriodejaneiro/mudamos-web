crumb :cycles do
  link 'Temas', admin_cycles_path
end

crumb :cycle do |c|
  link c.name, admin_cycles_path(c)
  parent :cycles
end

crumb :new_cycle do |c|
  link "Novo", new_admin_cycle_path
  parent :cycles
end

crumb :edit_cycle do |c|
  link "Editar", edit_admin_cycle_path(c)
  parent :cycle, c
end

crumb :blog_posts do |c|
  if c
    link 'Blog', admin_cycle_blog_posts_path(c)
    parent :cycle, c
  else
    link 'Blog', admin_blog_posts_path
  end
end

crumb :blog_post do |bp, c|
  if c
    link bp.title, admin_cycle_blog_post_path(c, bp)
  else
    link bp.title, admin_blog_post_path(bp)
  end
  parent :blog_posts, c
end

crumb :new_blog_post do |c|
  link 'Novo Post', new_admin_blog_post_path
  parent :blog_posts, c
end

crumb :edit_blog_post do |bp, c|
  link 'Editar Post', edit_admin_blog_post_path(bp)
  parent :blog_post, bp, c
end

crumb :highlights do
  link 'Destaques', admin_grid_highlights_path
end

crumb :settings do
  link 'Institucional Mudamos', admin_path
end

crumb :settings_edit do
  link 'Editar', admin_settings_path
  parent :settings
end

crumb :admin_users do
  link 'Administradores', admin_admin_users_path
end

crumb :admin_user do |a|
  link 'Editar Administrador', edit_admin_admin_user_path(a)
  parent :admin_users
end

crumb :new_admin_user do
  link 'Novo Administrador', new_admin_admin_user_path
  parent :admin_users
end

crumb :users do |c|
  if c
    link 'Usuários', admin_cycle_users_path(c)
    parent :cycle, c
  else
    link 'Usuários', admin_users_path
  end
end

crumb :user do |u, c|
  if c
    link u.name, admin_cycle_user_path(c, u)
  else
    link u.name, admin_users_path(u)
  end

  parent :users, c
end

crumb :static_pages do
  link 'Páginas Estáticas', root_path
end

crumb :static_page do |sp|
  link sp.name, admin_static_page_path(sp)
  parent :static_pages
end

crumb :static_page_form do |sp|
  if sp.new_record?
    link "Nova", new_admin_static_page_path
    parent :static_pages
  else
    link "Editar", edit_admin_static_page_path(sp)
    parent :static_page, sp
  end
end

crumb :credits do
  link 'Créditos', admin_credits_path
end

crumb :credit do |c|
  link c.name, admin_credits_path
  parent :credits
end

crumb :credit_form do |c|
  if c.new_record?
    link "Novo", new_admin_credit_path
    parent :credits
  else
    link "Editar", edit_admin_credit_path(c)
    parent :credit, c
  end
end

crumb :credit_categories do
  link 'Categorias de Créditos', admin_credits_path
end

crumb :credit_category do |cc|
  link cc.name, edit_admin_credit_category_path(cc)
  parent :credit_categories
end

crumb :credit_category_form do |cc|
  if cc.new_record?
    link 'Novo', new_admin_credit_category_path
    parent :credit_categories
  else
    link 'Editar', edit_admin_credit_category_path(cc)
    parent :credit_category, cc
  end
end

crumb :subjects do |c, pr|
  link 'Assuntos', admin_cycle_plugin_relation_subjects_path(c, pr)
  parent :cycle, c
end

crumb :new_subject do |c, pr|
  link 'Novo', new_admin_cycle_plugin_relation_subject_path(c, pr)
  parent :subjects, c, pr
end

crumb :subject do |s, c, pr|
  link s.title, admin_cycle_plugin_relation_subject_path(c, pr, s)
  parent :subjects, c, pr
end

crumb :edit_subject do |s, c, pr|
  link 'Editar', edit_admin_cycle_plugin_relation_subject_path(c, pr, s)
  parent :subject, s, c, pr
end

(0..2).each do |i|
  crumb "c#{i}".to_sym do |comment, c, pr, s|
    link "c#{i}", admin_cycle_plugin_relation_subject_comment_path(c, pr, s, comment)
    if i == 0
      parent :subject, s, c, pr
    else
      parent "c#{i - 1}".to_sym, comment.parent, c, pr, s
    end
  end
end

crumb :comment do |comment, c, pr, s|
  link comment.id, admin_cycle_plugin_relation_subject_comment_path(c, pr, s, comment)

  if comment.depth == 0
    parent :subject, s, c, pr
  else
    parent "c#{comment.depth - 1}".to_sym, comment.parent, c, pr, s
  end
end

crumb :new_comment do |comment, c, pr, s|
  link 'Nova Resposta', new_admin_cycle_plugin_relation_subject_comment_comment_path(c, pr, s, comment)
  parent :comment, comment, c, pr, s
end

crumb :compilation do |c, pr|
  link 'Relatoria', admin_cycle_plugin_relation_path(c, pr)
  parent :cycle, c
end

crumb :materials do |c, pr|
  link 'Biblioteca', admin_cycle_plugin_relation_materials_path(c, pr)
  parent :cycle, c
end

crumb :new_material do |c, pr|
  link 'Novo', new_admin_cycle_plugin_relation_material_path(c, pr)
  parent :materials, c, pr
end

crumb :material do |m, c, pr|
  link m.title, edit_admin_cycle_plugin_relation_material_path(m, c, pr)
  parent :materials, c, pr
end

crumb :edit_material do |m, c, pr|
  link 'Editar', edit_admin_cycle_plugin_relation_material_path(m, c, pr)
  parent :material, m, c, pr
end

crumb :vocabularies do |c, pr|
  link 'Glossário', admin_cycle_plugin_relation_vocabularies_path(c, pr)
  parent :cycle, c
end

crumb :new_vocabulary do |c, pr|
  link 'Novo', new_admin_cycle_plugin_relation_vocabulary_path(c, pr)
  parent :vocabularies, c, pr
end

crumb :vocabulary do |v, c, pr|
  link v.title, edit_admin_cycle_plugin_relation_vocabulary_path(v, c, pr)
  parent :vocabularies, c, pr
end

crumb :edit_vocabulary do |v, c, pr|
  link 'Editar', edit_admin_cycle_plugin_relation_vocabulary_path(v, c, pr)
  parent :vocabulary, v, c, pr
end

crumb :charts do |c|
  link 'Gráficos Personalizados', admin_cycle_charts_path(c)
  parent :cycle, c
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
