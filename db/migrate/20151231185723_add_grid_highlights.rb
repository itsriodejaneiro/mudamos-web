class AddGridHighlights < ActiveRecord::Migration
  def up
    GridHighlight.where(target_object: Cycle.find_by_name('Segurança Pública')).first_or_create
    GridHighlight.where(target_object: SocialLink.find_by_provider('facebook')).first_or_create
    GridHighlight.where(target_object: BlogPost.find_by_slug('os-principais-desafios-no-debate-da-seguranca-publica')).first_or_create
    GridHighlight.where(target_object: BlogPost.find_by_slug('o-ingresso-nas-policias-e-a-progressao-na-carreira')).first_or_create
    GridHighlight.where(target_object: SocialLink.find_by_provider('twitter')).first_or_create
    GridHighlight.where(target_object: BlogPost.find_by_slug('ombudsperson-as-razoes-de-sette-camara')).first_or_create
    GridHighlight.where(target_object: Cycle.find_by_name('Segurança Pública'), vocabulary: true).first_or_create
    GridHighlight.where(target_object: BlogPost.find_by_slug('video-uma-proposta-de-mudanca-para-a-seguranca-publica-no-brasil')).first_or_create
    GridHighlight.where(blog: true).first_or_create
    GridHighlight.where(target_object: BlogPost.find_by_slug('glossario-seguranca-publica')).first_or_create
  end

  def down
  end
end
