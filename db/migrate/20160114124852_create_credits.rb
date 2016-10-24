class CreateCredits < ActiveRecord::Migration
  def up
    create_table :credits do |t|
      t.references :credit_category, index: true, foreign_key: true
      t.string :name
      t.text :content
      t.string :url
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :credits, :deleted_at

    counter = 0
    {
      'QUEM ESTÁ POR TRÁS?' => {
        'Realização' => {
          content: '<a href="http://itsrio.org/"><img src="/assets/logo_its-a7e476f2e16c733afbb7a6d6cc7fa08268e1b46c06ca058f24a2ee098467a083.png" alt="Logo its a7e476f2e16c733afbb7a6d6cc7fa08268e1b46c06ca058f24a2ee098467a083"></a>'
        },
        'Parceiros Estratégicos' => {
          content: '<a href="http://www.opensocietyfoundations.org/"><img src="/assets/logo-osf-e620bdb2b29d2600ae95c96cc420ee6750d9a6a56a4f75eb341bcaccde66fccc.png" alt="Logo osf e620bdb2b29d2600ae95c96cc420ee6750d9a6a56a4f75eb341bcaccde66fccc"></a><a href="http://www.arapyau.org.br/"><img src="/assets/logo-arapyau-e6573223a0e4661b7a3dfefcb2cf4f8a510f1ebe03a5b9fbcd7422050cdf95e7.png" alt="Logo arapyau e6573223a0e4661b7a3dfefcb2cf4f8a510f1ebe03a5b9fbcd7422050cdf95e7"></a>'
        }
      },
      'TEMA SEGURANÇA PÚBLICA' => {
        'Ficha Técnica' => {
          content: '<p><b>Consultoria Técnica:</b><span> Luiz Eduardo Soares</span></p><p><b>Conteúdo:</b><span>  Ernesto Salles, Fernanda Novaes Cruz e Hildebrando Saraiva</span></p><p><b>Design:</b><span> Marlena Szczepanik, Thiago Dias e Steffania Paola</span></p><p><b>Comunicação:</b><span> Juliana Lugão, Luiza Toschi, Natasha Felizi</span></p><p><b>Produção Audiovisual:</b><span> Formosa Filmes e Cinepoesias Produções</span></p>'
          },
        'Imagem Home Mudamos' => {
          content: '<a href="https://www.flickr.com/photos/-salvaje-">https://www.flickr.com/photos/-salvaje-</a>',
          url: 'http://www.mudamos.org'
        },
        'Imagem Home Segurança Pública' => {
          content: '<p>Celso Felix</p>',
          url: 'https://www.mudamos.org/temas/seguranca-publica'
        }
      },
      'TEMA REFORMA POLÍTICA DO SÉCULO XXI' => {
        'Consultoria Técnica' => {
          content: '<a href="http://www.iesp.uerj.br/"><img src="/assets/logo-iespuerj-2b494bf26999e06bb6a6039bf26e2156ad8f07638b7326b3d3ced0f885ed29fd.png" alt="Logo iespuerj 2b494bf26999e06bb6a6039bf26e2156ad8f07638b7326b3d3ced0f885ed29fd"></a>'
        },
        'Ficha Técnica' => {
          content: '<p><b>Conteúdo:</b><span> Evandro Sussekind, Fabiano Santos e Leonardo Martins Barbosa</span></p><p><b>Foto:</b><span> Mídia Ninja</span></p>'
        }
      },
      'DESENVOLVIMENTO' => {
        'Tecnologia e Design' => {
          content: '<img src="/assets/inventos-logo-sem-tag-2566dad55603e34d17f695a503902983c26929510d0c990001b0605f2a0b2299.jpg" alt="Inventos logo sem tag 2566dad55603e34d17f695a503902983c26929510d0c990001b0605f2a0b2299">'
        }
      }
    }.each do |k, v|
      cat = CreditCategory.create(name: k, position: counter)

      v.each do |k1, v1|
        args = v1.merge(name: k1)
        credit = cat.credits.new args
        credit.save
      end

      counter += 1
    end
  end

  def down
    drop_table :credits
  end
end
