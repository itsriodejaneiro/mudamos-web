namespace :settings do
  desc "Adds the new home blocks"
  task add_new_home_blocks: :environment do
    values = [
      {
        key: "home_block_1_title"
      },
      {
        key: "home_block_1_body",
        value: "<p><strong>Mudamos</strong> é uma caixa de ferramentas para você entender, participar e construir soluções de forma democrática na Internet.</p>"
      },
      {
        key: "home_block_1_icon",
        picture: "https://s3-sa-east-1.amazonaws.com/mudamos-images/images/home-block-phone.svg"
      },
      {
        key: "home_block_2_title",
        value: "Cada desafio público precisa de uma solução diferente"
      },
      {
        key: "home_block_2_body",
        value: "<p>É por isso que Mudamos reúne várias ferramentas de participação, que também podem ser usadas em conjunto</p>"
      },
      {
        key: "home_block_2_icon",
        picture: "https://s3-sa-east-1.amazonaws.com/mudamos-images/images/home-block-puzzle.svg"
      },
      {
        key: "home_block_3_title",
        value: "Priorize ideias"
      },
      {
        key: "home_block_3_body",
        value: "<p>Prorize ideias mais importantes.</p>"
      },
      {
        key: "home_block_3_icon",
        picture: "https://s3-sa-east-1.amazonaws.com/mudamos-images/images/home-block-priorize.svg"
      },
      {
        key: "home_block_4_title",
        value: "Discuta"
      },
      {
        key: "home_block_4_body",
        value: "<p>Debata questões, concorde e discorde de opiniões e produza debates informados.</p>"
      },
      {
        key: "home_block_4_icon",
        picture: "https://s3-sa-east-1.amazonaws.com/mudamos-images/images/home-block-discuta.svg"
      },
      {
        key: "home_block_5_title",
        value: "Assine"
      },
      {
        key: "home_block_5_body",
        value: "<p>Dê seu apoio a projetos de lei de iniciativa popular de forma eletrônica.</p>"
      },
      {
        key: "home_block_5_icon",
        picture: "https://s3-sa-east-1.amazonaws.com/mudamos-images/images/home-block-assine.svg"
      },
      {
        key: "home_block_6_title",
        value: "Entenda"
      },
      {
        key: "home_block_6_body",
        value: "<p>Use nosso glossário para participar de maneira informada.</p>"
      },
      {
        key: "home_block_6_icon",
        picture: "https://s3-sa-east-1.amazonaws.com/mudamos-images/images/home-block-entenda.svg"
      },
      {
        key: "home_block_7_title",
        value: "Acompanhe"
      },
      {
        key: "home_block_7_body",
        value: "<p>Lei os relatórios produzidos sobre os ciclos de mobilização.</p>"
      },
      {
        key: "home_block_7_icon",
        picture: "https://s3-sa-east-1.amazonaws.com/mudamos-images/images/home-block-acompanhe.svg"
      },
      {
        key: "home_block_8_title",
        value: "Mudamos funciona em ciclos de mobilização"
      },
      {
        key: "home_block_8_body",
        value: "<p>Cada ciclo tem seus próprios objetivos e usa diferentes <strong>conjuntos de ferramentas</strong> para atingi-los, buscando o maior <strong>impacto positivo</strong> possível de <strong>forma legítima</strong>. Os ciclos são compostos por diferentes fases definidas a priori de acordo com os objetivos de cada ciclo. Cada fase utiliza uma ferramenta para seu desenvolvimento.</p>"
      },
      {
        key: "home_block_8_icon",
        picture: "https://s3-sa-east-1.amazonaws.com/mudamos-images/images/home-block-arrows.svg"
      }
    ]

    values.each do |attributes|
      Setting.find_or_initialize_by(key: attributes[:key]) do |setting|
        setting.attributes = attributes
        setting.save!
      end
    end
  end

  desc "Destroys all home blocks"
  task remove_new_home_blocks: :environment do
    (1..8).each do |index|
      Setting.find_by_key("home_block_#{index}_title").really_destroy!
      Setting.find_by_key("home_block_#{index}_body").really_destroy!
      Setting.find_by_key("home_block_#{index}_icon").really_destroy!
    end
  end

  desc "Add home main video"
  task add_home_main_video: :environment do
    Setting.find_or_initialize_by(key: "home_main_video") do |setting|
      setting.video_url = "https://s3-sa-east-1.amazonaws.com/mudamos-video/home_header.mp4"
      setting.save!
    end
  end
end
