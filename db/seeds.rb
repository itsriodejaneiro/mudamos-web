# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# if Profile.count < 5
#   (5 - Profile.count).times { FactoryGirl.create(:profile) }
# end

{
  'Setor Público' => {
    description: 'Meu trabalho é em algum ramo do Estado, no executivo, legislativo ou judiciário, em qualquer esfera da federação União, Estados e Municípios.',
    children: {
      'Executivo' => {},
      'Legislativo' => {},
      'Judiciário' => {},
      'Ministério Público' => {},
      'Defensoria Pública' => {},
      'Forças Armadas' => {}
    }
  },
  'Educação' => {
    description: 'Sou professor/a, pesquisador/a, estudante ou alguém que trabalha no meio acadêmico com produção de conhecimento, ensino ou pesquisa.'
  },
  'Empresarial' => {
    description: 'Trabalho na área empresarial.'
  },
  'Cidadão' => {
    description: 'Quero colaborar no site como cidadão e não me sinto parte de nenhum dos outros setores listados.'
  },
  'Organização Sociedade Civil - ONG' => {
    description: 'Trabalho em organizações da sociedade civil, em redes descentralizadas, em ONGs, movimentos sociais, sindicatos e qualquer outra entidade do terceiro setor.'
  },
  'Segurança Pública' => {
    description: 'Sou profissional da segurança pública',
    children: {
      'Policial Civil Agente' => {
        description: 'Inspetor, Detetive, Oficial de Cartório, Escrivão, Escrevente, Comissário, Investigador.'
      },
      'Policial Civil Delegado' => {},
      'Policial Militar Oficial' => {},
      'Policial Militar Praça' => {},
      'Policial Federal Delegado' => {},
      'Policial Federal Agente' => {},
      'Policial Rodoviário Federal' => {},
      'Agente penitenciário' => {},
      'Guarda Municipal' => {},
      'Perito' => {},
      'Bombeiros' => {},
      'Outros' => {}
    }
  }
}.each do |k, v|
  p = Profile.where(name: k).first_or_initialize
  if v[:description]
    p.description = v[:description]
  end
  p.save

  if v[:children]
    v[:children].each do |k1, v1|
      p1 = Profile.where(name: k1).first_or_initialize
      p1.parent = p
      if v1[:description]
        p1.description = v1[:description]
      end
      p1.save
    end
  end
end


Setting.where(
  key:'home_sub_title',
  value:'Participe do debate e ajude a construir o Brasil que queremos.'
).first_or_create

Setting.where(
  key:'home_title1',
  value:'O que é Mudamos?'
).first_or_create

Setting.where(
  key:'home_text1',
  value:'<p>Somos uma plataforma online para você opinar com liberdade e segurança sobre temas importantes de interesse público, ajudando na construção democrática de soluções. Nosso objetivo é criar um debate informado com a participação de pessoas de vários setores da sociedade.</p><a class="more" href="/blog/por-que-mudamos">Saiba mais</a>'
).first_or_create

Setting.where(
  key:'home_title2',
  value:'Como funciona?'
).first_or_create

Setting.where(
  key:'home_text2',
  value:'<p>Os temas s&atilde;o tratados em ciclos, nos quais &eacute; poss&iacute;vel defender suas ideias e interagir com outros participantes. Todo o processo &eacute; aberto e ser&aacute; acompanhado de perto por um <a href="blog/comite-de-transparencia">Comit&ecirc;</a> que garante transpar&ecirc;ncia no debate. Ao final de cada ciclo, as contribui&ccedil;&otilde;es s&atilde;o organizadas em documentos e entregues diretamente aos agentes p&uacute;blicos respons&aacute;veis por sua implementa&ccedil;&atilde;o.</p>
<p><a class="more" href="blog/como-funciona">Saiba mais</a></p>'
).first_or_create

Setting.where(
  key:'home_title3',
  value:'Quem está por trás?'
).first_or_create

Setting.where(
  key:'home_text3',
  value:'<p><strong>MUDAMOS</strong><span style="font-weight: 400;"> foi idealizado e desenvolvido pelo </span><a href="http://itsrio.org/" target="_blank"><span style="font-weight: 400;">Instituto de Tecnologia e Sociedade (ITS Rio)</span></a><span style="font-weight: 400;"> com o apoio de parceiros para a sua realiza&ccedil;&atilde;o e o acompanhamento de especialistas para cada tema debatido.</span></p><form action="https://pagseguro.uol.com.br/checkout/v2/donation.html" method="post"><!-- NÃO EDITE OS COMANDOS DAS LINHAS ABAIXO --><input type="hidden" name="currency" value="BRL" /><input type="hidden" name="receiverEmail" value="itsrio@itsrio.org" /><p><span style="font-weight: 400;">O projeto &eacute; financiado pela </span><a href="https://www.opensocietyfoundations.org/" target="_blank"><span style="font-weight: 400;">Open Society Foundations</span></a><span style="font-weight: 400;">, pelo </span><a href="http://www.arapyau.org.br/" target="_blank"><span style="font-weight: 400;">Instituto Arapya&uacute;</span></a> <span style="font-weight: 400;">e quem mais quiser apoiar. Caso tenha interesse, acesse </span><button style="background-color: transparent; border: 0;" type="submit">este link</button><span style="font-weight: 400;">.</span></p></form>'
).first_or_create

header_file = File.new "#{Rails.root}/app/assets/images/Floresta_1.jpg", "r"

Setting.where(
    key: "home_header"
).first_or_create(
    picture: header_file
)

logo = File.new "#{Rails.root}/app/assets/images/mudamos-logo.svg", "r"

Setting.where(
    key: "logo"
).first_or_create(
    picture: logo
)

logo_png = File.new "#{Rails.root}/app/assets/images/mudamos-logo-new1-01.png", "r"

Setting.where(
    key: "logo_png"
).first_or_create(
    picture: logo_png
)


SocialLink.where(
  provider: 'facebook',
  name: 'fb.com/mudamos',
  link: 'https://www.facebook.com/mudamos',
  icon_class: 'icon-facebook',
  description: 'MUDAMOS também está no Facebook'
).first_or_create

SocialLink.where(
  provider: 'twitter',
  name: '@MUDAMOSorg',
  link: 'https://twitter.com/mudamosorg',
  icon_class: 'icon-twitter',
  description: 'SIGA NOSSO TWITTER'
).first_or_create

seg_pub_file = File.new "#{Rails.root}/app/assets/images/IMG_9209.jpg", "r"

seg_publica_cycle = Cycle.where(
  name: 'Segurança Pública',
  subdomain: 'seguranca-publica' ,
  title: 'Segurança Pública'
).first_or_create(
  about: Faker::Lorem.paragraph ,
  initial_date: Time.now,
  final_date:Time.now + 1.year,
  slug: 'seguranca-publica',
  color: '#f86048',
  description: "<p>O sistema brasileiro de segurança pública está desatualizado para o contexto político e momento histórico atuais. Desde o regime militar, não houve alterações estruturais significativas. Vamos discutir uma proposta de mudança?</p>",
  picture: 'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/IMG_9209.jpg'
)

# ref_politica_cycle = Cycle.where(
#   name: 'Reforma Política',
#   subdomain: 'rf' ,
#   title: 'Reforma Política'
# ).first_or_create(
#   about: Faker::Lorem.paragraph ,
#   initial_date: Time.now,
#   final_date:Time.now + 1.year,
#   slug: 'reforma-politica',
#   color: '#d8ca00',
#   description: "<p>#{Faker::Lorem.paragraph}</p>"
# )

if seg_publica_cycle.phases.empty?
  FactoryGirl.create(:phase,
    cycle: seg_publica_cycle,
    initial_date: Time.zone.parse('2015-10-26 00:00T-0300'),
    final_date: Time.zone.parse('2016-2-26 00:00T-0300'),
    name: 'Participação',
    description: 'Responda às perguntas e ajude a construir uma proposta de mudança.'
  )

  FactoryGirl.create(:phase,
    cycle: seg_publica_cycle,
    initial_date: Time.zone.parse('2016-02-29 00:00T-0300'),
    final_date: Time.zone.parse('2016-04-29 00:00T-0300'),
    name: 'Relatoria',
    description: 'Organização de todas contribuições em documentos que representarão o debate.'
  )
end

# if ref_politica_cycle.phases.empty?
#   FactoryGirl.create(:phase,
#     cycle: ref_politica_cycle,
#     initial_date: Time.now,
#     final_date: Time.now + 1.year
#   )
# end

unless plugin_blog = Plugin.find_by_name('Blog')
  plugin_blog = FactoryGirl.create(:plugin,
    name:'Blog',
    plugin_type:'Blog',
    icon_class: ''
  )
end

unless plugin_discussao = Plugin.find_by_name('Discussão')
  plugin_discussao = FactoryGirl.create(:plugin,
    name:'Discussão',
    plugin_type:'Discussão',
    icon_class: 'discussion'
  )
end

unless plugin_relatoria = Plugin.find_by_name('Relatoria')
  plugin_relatoria = FactoryGirl.create(:plugin,
    name:'Relatoria',
    plugin_type:'Relatoria',
    icon_class: 'compilation'
  )
end

# unless plugin_rf = Plugin.find_by_name('Blog Reforma Política')
#   plugin_rf = FactoryGirl.create(:plugin,
#     name:'Blog Reforma Politica',
#     plugin_type:'Blog'
#   )
# end

unless plugin_relation_blog_sp = PluginRelation.where(
  related: seg_publica_cycle,
  plugin: plugin_blog
).first
  plugin_relation_blog_sp = FactoryGirl.create(:cycle_plugin_relation,
    related: seg_publica_cycle,
    plugin: plugin_blog
  )
end

unless plugin_relation_discussao_sp = PluginRelation.where(
  related: Phase.where(name: 'Participação', cycle: seg_publica_cycle).first,
  plugin: plugin_discussao
).first
  plugin_relation_discussao_sp = FactoryGirl.create(:cycle_plugin_relation,
    related: Phase.where(name: 'Participação', cycle: seg_publica_cycle).first,
    plugin: plugin_discussao
  )
end

unless plugin_relation_relatoria_sp = PluginRelation.where(
  related: Phase.where(name: 'Relatoria', cycle: seg_publica_cycle).first,
  plugin: plugin_relatoria
).first
  plugin_relation_relatoria_sp = FactoryGirl.create(:cycle_plugin_relation,
    related: Phase.where(name: 'Relatoria', cycle: seg_publica_cycle).first,
    plugin: plugin_relatoria
  )
end

# unless plugin_relation_blog_rf = PluginRelation.where(
#   related: ref_politica_cycle,
#   plugin: plugin_rf
# ).first
#   plugin_relation_blog_rf = FactoryGirl.create(:cycle_plugin_relation,
#     related: ref_politica_cycle,
#     plugin:plugin_rf
#   )
# end

# if BlogPost.count < 6
#   (6 - BlogPost.count).times do
#     FactoryGirl.create(:blog_post, plugin_relation: plugin_relation_blog_sp)
#     FactoryGirl.create(:blog_post, plugin_relation: plugin_relation_blog_rf)
#   end
# end

Vocabulary.where(title: 'Estado democrático de direito').first_or_create(cycle: seg_publica_cycle,
  description: '<p>O Estado democrático de direito é um complexo de instituições, divididas entre três esferas de poder --Executivo, Legislativo e Judiciário—regidas por uma Constituição, a qual, embora expressando a vontade majoritária da população, compromete-se a respeitar as minorias. Assim como acontece com as outras formas estatais, O Estado democrático de direito detém o monopólio do uso da força, sendo que, neste caso, tal prerrogativa reivindica uma qualidade distintiva, a legitimidade, porque é autorizado pela vontade popular, circunscrita pelo respeito às minorias.</p>'
)

Vocabulary.where(title: 'Polícia').first_or_create(cycle: seg_publica_cycle,
  description: '<p>O monopólio do uso da força, que caracteriza o Estado, e o monopólio do uso legítimo da força, que define o Estado democrático de direito, são exercidos por meio de instituições específicas: as Forças Armadas, quando a força, real ou potencial, aplica-se para defender o território e a soberania nacionais, contra ameaças externas; e as Polícias, quando a força, real ou potencial, aplica-se para garantir a fruição, pelos cidadãos, de seus direitos, ante a iminência de violações, ou para detê-las, quando em curso, ou para prevení-las e contribuir para reparar seus efeitos, por meio da participação nos mecanismos de persecução criminal, os quais implicam investigação, identificação de responsabilidades, prestação de denúncia, a cargo do Ministério Público, julgamento e prolatação de sentenças, atribuições da Justiça –sentenças eventualmente cumpridas no sistema penitenciário, quando determinar privação de liberdade. As aplicações da força são limitadas pelos princípios da proporcionalidade e do comedimento. As Forças Armadas formam o sistema de defesa e as Polícias, de segurança pública, o qual se vincula ao campo da Justiça criminal.<p>'
)

Vocabulary.where(title: 'Ordem Pública').first_or_create(cycle: seg_publica_cycle,
  description: '<p>Segundo o artigo 144 da Constituição federal, “a segurança pública é dever do Estado e direito, e responsabilidade, de todos, sendo exercida para a preservação da ordem pública e da incolumidade das pessoas e do patrimônio, através das polícias e do corpo de bombeiros”. É possível ir além do texto constitucional citado acima, adotando uma perspectiva mais sociológica do que jurídica. Ordem pública, deste ponto de vista, pode ser interpretada como a correspondência (aproximada ou tendencial) entre os padrões normativos identificados na descrição objetiva das relações sociais cotidianas e os parâmetros legais e valorativos fixados na Constiuição. Portanto, ordem não é sinônimo de ausência de conflito, nem da mera reprodução conservadora de tradições e rotinas, ou de imposição autoritária e arbitrária de algum tipo de comportamento. Ordem pública, no Estado democrático de direito, equivale à aplicação na vida prática da sociedade dos princípios constitucionais. Em outras palavras, equivale ao respeito universal aos direitos, ou à identificação generalizada de que as garantias são, têm sido e serão garantidas, ou que, pelo menos, esta é a tendência predominante. O mais importante a observar é exatamente este ponto: se há razoável consenso quanto ao fato de que esta hipótese positiva constitua a tendência mais forte, haverá também a crença amplamente compartilhada de que o futuro próximo mais provável será caracterizado pela reiteração da garantia dos direitos. E como a ordem não é estática, está sempre em movimento, sendo, como é, o resultado momentâneo das ações e decisões dos indivíduos e dos grupos, a possibilidade de que o futuro positivo se confirme torna-se mais forte na medida em que todos creiam que assim será, posto que suas decisões serão orientadas por esta expectativa favorável. E aqui passamos do conceito de ordem ao conceito de segurança pública.<p>'
)

Vocabulary.where(title: 'Segurança Pública').first_or_create(cycle: seg_publica_cycle,
  description: '<p>O primeiro impulso de quem se dedica a pensar o tema é conceber segurança como ausência de crimes ou violência. Mesmo sendo uma realidade utópica, valeria como referência, modelo ou tipo ideal. No entanto, há duas questões a enfrentar: (1) crime não existe antes que uma lei assim o defina. O fato, por exemplo, de que beber álcool seja declarado crime não faz com que a abstinência represente segurança, nem para quem gosta da bebida proibida, nem mesmo para os demais, uma vez que a proibição pode significar perseguições, medo e a criação do tráfico de bebidas, como ocorreu na Lei Seca, nos Estados Unidos, na década de 30 do século passado. Por outro lado, e violência é uma categoria cultural muito variável, a depender da cultura e do momento histórico. Além disso, há a violência positiva e a negativa, de acordo com critérios em disputa. Tome-se como exemplo o caso das lutas esportivas ou a circunstância em que um ato violento impede a violência arbitrária cometida contra inocentes. (2) E se a ausência de crimes retratar a paz dos cemitérios, isto é, resultar da repressão brutal por parte de um Estado totalitário? Alguém se sente seguro sob um regime ditatorial? A resposta é não. Ou seja, o terror do Estado provê a ordem oriunda do medo, a previsibilidade derivada da mais radical insegurança, não a ordem que deriva da confiança, abrindo espaço para o exercício da liberdade e da criatividade. Portanto, é preciso incluir uma mediação entre ordem e segurança públicas: o Estado democrático de direito. É apenas em seu âmbito que ordem e segurança se afinam. Ao trazer o tipo de Estado para o centro das reflexões, afastamos a aplicabilidade do conceito segurança pública às sociedades sem Estado, para as quais não fazem sentido as ideias de lei, polícia e justiça criminal.</p><p>Quando indagamos se alguém sente-se seguro numa ditadura, introduzimos uma noção fundamental: a sensação (de medo ou tranquilidade, instabilidade ou confiança, insegurança ou segurança), a qual deriva da percepção que temos sobre as interações de que participamos, sobre o contexto em que nos situamos e as circunstâncias em torno de nós e das pessoas significativas para nós. No fundo, tudo se resume à confiança que julgamos poder depositar nos outros, especialmente naqueles que desconhecemos. Confiar ou desconfiar, este é o segredo. É disso que depende o convívio que denominamos vida social. Estado existe para reduzir a desconfiança, assim como suas instituições que respondem por ordem pública e segurança não constituem, em boa medida, operadores dos sentimentos, na medida em que funcionem como redutores da desconfiança e do medo. Elas são, no modelo ideal, personificações da autoridade, mecanismo que converte medo em confiança. Por que estamos tratando de sentimentos e não da substância da segurança, segundo a visão usual: os crimes e seu controle? Claro que reduzir crimes importa, mas não basta. Longe disso. Senão vejamos: alguém seria capaz de indicar um determinado número de assassinatos como sendo o limite que separa a sociedade segura de outra insegura? A segurança pode ser definida quantitativamente? A resposta seria sim apenas quando o número for zero. Mas desse modo limitamos o conceito segurança pública ao modelo ideal, praticamente irrealizável, salvo excepcionalmente. Claro que quão mais próximo o número fosse de zero, mais segura a sociedade seria, desde que, vale insistir, o contexto fosse o Estado democrático de direito e não o totalitarismo arbitrário. No entanto, como lidar com fenômenos tão comuns que têm a ver com os limites da comparação? Seja a comparação entre os crimes e como cada modalidade de prática criminosa afeta as percepções (as quais dependem dos vínculos de cada indivíduo com os territórios mais vulneráveis e também da natureza das narrativas midiáticas que divulgam os crimes); seja a comparação entre o presente e o passado (ou a memória seletiva) de cada sociedade; seja a comparação entre diferentes sociedades. Focalizando apenas um exemplo: para uma pequena cidade em que nada grave acontece, um homicídio pode disseminar o medo e desencadear comportamentos agressivos que, em nome da autodefesa, terminem por precipitar o efeito que se deseja evitar. Um número considerado assustador em uma cidade pode ser percebido como tranquilizador, em outra, indicando declínio da insegurança. O crescimento de assaltos pode suscitar uma onda de medo e insegurança, mesmo que os crimes contra a vida, os mais graves, estejam em declínio. O que uns percebem, outros ignoram, uma vez que a mídia não trata com equidade todos os casos e que os espaços urbanos são muito desiguais, em todos os sentidos, inclusive quanto à vulnerabilidade à prática de crimes, especialmente os mais violentos. Além disso, a experiência da insegurança pode crescer, contrariando os dados, porque mais gente vai, a cada ano, ingressando no universo das vítimas de um ou outro tipo de crime. Quem já foi vítima não esquece o que sofreu, não deixa de participar do universo das vítimas no ano seguinte, apenas porque não voltou a ser vítima.</p><p>De que adianta informar aos cidadãos que se reduziu a probabilidade de que ele ou ela, ou seus filhos, vizinhos, parentes e amigos, sejam vítimas de crime, se permanece negativa a percepção compartilhada, ainda que desigualmente distribuída entre classes sociais, grupos etários e habitantes de áreas diferentes? A confiança não se restabelece simplesmente pela divulgação de números mais favoráveis, até porque probabilidades valem para a coletividade, não para indivíduos. Isso mostra que, ainda que analiticamente seja necessário fazê-lo, no fluxo da vida real, a sensação, fruto da percepção, e os eventos criminais --ou assim interpretados-- são duas faces da mesma moeda, são dimensões inseparáveis, e ambas as faces têm de ser levadas em conta tanto na conceitualização da segurança quanto na elaboração de diagnósticos e de planos de ação institucionais e governamentais. Observe-se que as percepções, ainda que não se fundamentem exclusivamente na identificação de eventos criminais, reconhecem sua existência e lhes atribuem valor segundo escalas próprias e variadas.</p><p>A conclusão conduz a uma definição que sintetiza o conjunto das reflexões apresentadas: segurança pública é a estabilização, e a universalização, de expectativas favoráveis quanto às interações sociais. Ou, em outras palavras, segurança é a generalização da confiança na ordem pública, a qual corresponde à profecia que se auto-cumpre e à capacidade do poder público de prevenir intervenções que obstruam este processo de conversão das expectativas positivas em confirmações reiteradas. Compreende-se, neste contexto, por que a postura dos policiais é tão decisiva: seu foco não são apenas os crimes, sua prevenção, ou a persecução criminal, mas também o estabelecimento de laços de respeito e confiança com a sociedade, sem os quais a própria confiança nas relações sociais dificilmente se consolida. Ordem tem menos a ver com força ou repressão do que com vínculos de respeito e confiança.</p>'
)

Vocabulary.where(title: 'Polícia Militar').first_or_create(cycle: seg_publica_cycle,
  description: '<p>De acordo com o artigo 144 da Constituição federal, às polícias militares cabem a polícia ostensiva e a preservação da ordem pública. As polícias militares são forças auxiliares e reserva do Exército, e subordinam-se, juntamente com as polícias civis, aos Governadores dos Estados, do Distrito Federal e dos Territórios.</p>'
)

Vocabulary.where(title: 'Polícia Civil').first_or_create(cycle: seg_publica_cycle,
  description: '<p>Afirma a Constituição federal, em seu artigo 144, que às polícias civis, dirigidas por delegados de polícia de carreira, incumbem, ressalvada a competência da União, as funções de polícia judiciária e a apuração de infrações penais, exceto as militares.</p>'
)

Vocabulary.where(title: 'Polícia Federal').first_or_create(cycle: seg_publica_cycle,
  description: '<p>Segundo a Constituição federal, em seu artigo 144, a polícia federal, instituída por lei como órgão permanente, organizado e mantido pela União e estruturado em carreira, destina-se a: (Redação dada pela Emenda Constitucional nº 19, de 1998)</p><p>I - apurar infrações penais contra a ordem política e social ou em detrimento de bens, serviços e interesses da União ou de suas entidades autárquicas e empresas públicas, assim como outras infrações cuja prática tenha repercussão interestadual ou internacional e exija repressão uniforme, segundo se dispuser em lei;</p><p>II - prevenir e reprimir o tráfico ilícito de entorpecentes e drogas afins, o contrabando e o descaminho, sem prejuízo da ação fazendária e de outros órgãos públicos nas respectivas áreas de competência;</p><p>III - exercer as funções de polícia marítima, aeroportuária e de fronteiras; (Redação dada pela Emenda Constitucional nº 19, de 1998)</p><p>IV - exercer, com exclusividade, as funções de polícia judiciária da União.</p>'
)

Vocabulary.where(title: 'Polícia Rodoviária Federal').first_or_create(cycle: seg_publica_cycle,
  description: '<p>Diz o artigo 144 da Constituição federal que a polícia rodoviária federal, órgão permanente, organizado e mantido pela União e estruturado em carreira, destina-se, na forma da lei, ao patrulhamento ostensivo das rodovias federais. (Redação dada pela Emenda Constitucional nº 19, de 1998)</p>'
)

Vocabulary.where(title: 'Guarda Municipal').first_or_create(cycle: seg_publica_cycle,
  description: '<p>Os municípios, segundo o artigo 144 da Constituição Federal, poderão constituir guardas municipais destinadas à proteção de seus bens, serviços e instalações, conforme dispuser a lei. Observe-se que esta definição constitucional não corresponde à realidade que se observa no Brasil contemporâneo, na qual há centenas de Guardas Municipais que atuam como entidades análogas às instituições policiais, particularmente às polícias militares. Fazem muito mais do que proteger bens, serviços e instalações municipais. Elas se tornaram personagens importantes demais para permanecer à margem da arquitetura institucional da segurança pública.</p>'
)

Vocabulary.where(title: 'Arquitetura Institucional da Segurança Pública').first_or_create(cycle: seg_publica_cycle,
  description: '<p>São as instituições que atuam no campo da segurança pública, em todo o país, e o arranjo formal que limita, impõe e dita os termos de suas interrelações, estabelecendo também as condições nas quais dar-se-ão as conexões entre elas e as instituições que não pertencem ao campo específico da segurança pública. O arranjo institui um sistema que não é autossuficiente, uma vez que complementa e é complementado por outras instituições e estruturas institucionais, como a Justiça criminal e o sistema penitenciário. Além disso, harmoniza-se com o ordenamento federalista brasileiro, em cujo âmbito aos estados e municípios atribui-se autonomia relativa. Assim, a arquitetura institucional da segurança pública, desenhada pela Constituição federal, envolve a distribuição de responsabilidades e autoridade entre a União e os entes federados, assim como a identificação dos atores institucionais, sobretudo as polícias.</p>'
)

Vocabulary.where(title: 'Modelo Policial').first_or_create(cycle: seg_publica_cycle,
  description: '<p>É a definição constitucional das características organizacionais, de suas interrelações e das funções conferidas às polícias, enquanto atores inscritos na arquitetura institucional da segurança pública. No caso brasileiro, o modelo prevê a existência de duas polícias federais e duas polícias em cada estado e no Distrito Federal, uma civil, outra militar, à primeira cabendo a investigação criminal, à segunda, a prevenção e a preservação da ordem pública. O modelo determina, portanto, a divisão do ciclo do trabalho policial em duas partes, conferindo a cada polícia estadual uma parte das tarefas. Observe-se que o modelo policial brasileiro, segundo a Constituição federal, não inclui as Guardas Municipais. A Constituição atribui-lhes papel limitado e específico: a proteção de bens, serviços e instalações municipais. Registre-se que a relativa marginalização do município, verificada no artigo 144 da Constituição Federal, colide com a tendência nacional de compartilhamento quando não municipalização das políticas públicas, como se constata em áreas como educação, saúde e ação social.</p>'
)

Vocabulary.where(title: 'Ciclo Completo').first_or_create(cycle: seg_publica_cycle,
  description: '<p>Refere-se ao conjunto de tarefas constitucionalmente atribuídas às instituições policiais, as quais envolvem a investigação criminal e o trabalho ostensivo, uniformizado, preventivo. No caso brasileiro, o modelo policial previsto pela Constituição veda que à mesma instituição policial, com exceção da Polícia Federal, seja conferida a responsabilidade de cumprir o ciclo completo.</p>'
)

Vocabulary.where(title: 'Carreira Única').first_or_create(cycle: seg_publica_cycle,
  description: '<p>Descreve um certo tipo de trajetória profissional prescrita por cada instituição (no caso, policial) cuja característica distintiva é o ingresso único e, portanto, comum, sem prejuízo das especialidades e das ramificações de funções, assim como das hierarquizações internas, as quais dependerão, ao longo do exercício profissional, da avaliação de méritos individuais, de exames sobre a competência e de avaliações de desempenho. Nas polícias federal, civis e militares, há duas portas de entrada: uma para o cargo de delegado, outra para os demais cargos; uma para a posição de oficial; outra para praças. </p>'
)

Vocabulary.where(title: 'Política de Segurança').first_or_create(cycle: seg_publica_cycle,
  description: '<p>É um conjunto sistemático de programas, projetos e ações (de natureza preventiva e/ou repressiva, no sentido que a persecução criminal confere ao termo) --concebidos a partir de diagnósticos continuamente revisados, atualizados e monitorados com base em avaliações dos resultados obtidos—a serem empreendidos pelas polícias e pelas demais agências que funcionam sob a autoridade da secretaria de segurança pública (ou de entidade análoga), os quais serão executados em consonância com os marcos legais vigentes, visando a efetivação prática, tão plena quanto possível, da garantia constitucional de acesso universal e equitativo dos cidadãos a seus direitos individuais e coletivos. A secretaria de segurança vale-se também, para a implementação da política que lhe cabe gerir, da mobilização de parcerias ou acordos cooperativos com outros órgãos governamentais das três esferas do poder executivo –municipal, estadual e federal--, com as instituições inscritas no campo da Justiça criminal e com atores da sociedades civil, sem abdicação de suas responsabilidades exclusivas. Observe-se que programas, projetos e ações podem incluir mudanças de mecanismos e procedimentos policiais, nos limites circunscritos pelos marcos constitucionais vigentes, posto que os órgãos sob sua autoridade correspondem a meios para a aplicação da política pública em pauta. Em síntese, a política de segurança, como toda política pública, caracteriza-se por identificar prioridades e estabelecer meios de atendê-las, mobilizando para este fim seus recursos humanos, intelectuais, tecnológicos, materiais e financeiros. O grande desafio para as políticas públicas, especialmente para as políticas de segurança, são os efeitos não antecipados das ações sociais (individuais, coletivas ou promovidas por instituições), também denominados efeitos de agregação ou efeitos perversos, por um lado, e a impermeabilidade das instituições, por outro. Por impermeabilidade entendem-se aqui as limitações impostas a eventuais intervenções transformadoras das políticas de segurança nas estruturas organizacionais das polícias pela arquitetura institucional da segurança pública --a qual inclui o modelo policial--, estabelecida pela Constituição federal.</p>'
)

Vocabulary.where(title: 'Gestão da Segurança Pública').first_or_create(cycle: seg_publica_cycle,
  description: '<p>Refere-se à orientação prática e administrativa do conjunto das instituições que atuam no campo da segurança pública, às quais cumpre executar a política definida pela secretaria de segurança ou entidade análoga. Portanto, a gestão operacionaliza as decisões políticas superiores, adotadas no âmbito da secretaria, fazendo com que as máquinas institucionais funcionem de modo a realizar os objetivos estipulados pela política de segurança, do modo mais adequado ao cumprimento desses objetivos, respeitados os princípios constitucionais. Uma vez que outras instituições, além daquelas subordinadas à secretaria, podem participar da implementação da política de segurança, por decisão própria ou determinação superior, a gestão da segurança pode abrir-se a parcerias, desde que suas responsabilidades específicas não sejam abandonadas ou transferidas a terceiros. Observe-se que a gestão tem de ater-se a fazer funcionar --melhor ou pior, com mais ou menos efetividade, numa ou noutra direção—os mecanismos institucionais sob seu comando ou a máquina de que dispõe, assim como os profissionais com que pode contar –já formados, alimentados em certas tradições e imersos em determinada cultura corporativa. Em suma, uma gestão não molda a instituição que dirige, nem a submete integralmente a seu comando, mesmo que as engrenagens institucionais favoreçam a governança. Convém registrar que a disciplina fruto da rigidez hierárquica e da centralização decisória, e de regimentos severos e repressivos, não implica elevada qualidade da governança, salvo em circunstâncias excepcionais. Esta qualidade em geral provém da magnitude e da intensidade da participação dos profissionais, em ambiente que estimule a confiança e a criatividade, o que pressupõe descentralização e distribuição de responsabilidades. Por isso, é preciso considerar os limites que as estruturas organizacionais --e outros fatores como a tradição corporativa-- impõem à gestão, assim como a inviabilidade de uma política pública insensível aos limites da gestão que a porá em marcha.</p>'
)

Vocabulary.where(title: 'Política Criminal').first_or_create(cycle: seg_publica_cycle,
  description: '<p>É o conjunto das decisões legislativas que classificam determinadas práticas como criminosas, vedando-as e as tornando alvo de políticas de segurança ou, mais especificamente, de ações policiais e judiciais, que envolvem sanções e penalizações. Assim como as políticas públicas formuladas e aplicadas pelo poder executivo, a política criminal, estipulada pelo poder legislativo e implementada pelo poder judiciário --uma vez empreendida a persecução criminal na esfera policial, isto é, do executivo--, enfrenta o dilema dos efeitos perversos. Por exemplo, se a vontade dos legisladores é proibir o acesso da população a determinadas substâncias psicoativas –ou inibir este acesso e reduzir o consumo—não alcançará necessariamente seus objetivos se declarar proibido o acesso. Fazendo-o pode, em vez de obter o resultado esperado, estimular práticas criminosas muito mais graves, além de ferir princípios matriciais da Constituição. Portanto, a política criminal não pode cingir-se a expressar dogmas, crenças, convicções e valores. Se pretende ter compromisso com as consequências que deseja produzir, tem de antecipar os efeitos de sua aplicação, quando as normas criadas atravessarem as teias complexas e dinâmicas do social.</p>'
)

Vocabulary.where(title: 'Desmilitarizar').first_or_create(cycle: seg_publica_cycle,
  description: '<p>Não se trata de um conceito nem mesmo de uma categoria cujo significado seja consensual. Há quem defina a palavra atribuindo-lhe um significado político e cultural, visando estimular mudanças no comportamento dos policiais. Entendem que sendo militares, os profissionais tenderiam naturalmente a conceber seu ofício não como a prestação de um serviço público destinado à cidadania, mas como combate ao inimigo interno, o que elevaria a violência a graus inaceitáveis e conflitantes com a natureza de instituições policiais submetidas ao Estado democrático de direito. Há os que pensam desmilitarização na clave dos direitos dos policiais enquanto cidadãos trabalhadores: o caráter militar das instituições refletir-se-ia em regimentos disciplinares draconianos e inconstitucionais, que violariam os direitos dos profissionais. Nesse contexto, dar-se-ia a super-exploração da força de trabalho policial, calada e domesticada pelo arbítrio punitivo dos superiores sobre os subalternos, em benefício de governos estaduais insensíveis à dignidade do trabalho e aos direitos humanos dos operadores da segurança pública menos graduados. Impedidos de se organizar, criticar, propor mudanças e formular demandas, os policiais seriam as primeiras e principais vítimas de um ordenamento discricionário e autoritário. Há ainda os que evocam a desmilitarização e a defendem, sustentando que as características militares da instituição só teriam como função proporcionar condições para o exercício eficiente do controle interno, viabilizando uma governança competente e eficiente. Constatando que as PMs têm demonstrado inúmeros e frequentes exemplos de que não há controle interno eficiente, tantos e tão seguidos são os casos de corrupção e brutalidade ilegal, deduzem que desmoronou a última razão que poderia justificar a manutenção da forma militar de organização das polícias ostensivas estaduais brasileiras.</p><p>Mesmo concordando com as abordagens referidas, a perspectiva que inspirou a PEC-51 enfatiza outro aspecto ao propor a desmilitarização, até porque entende a natureza militar da polícia de um modo bastante específico. Em nosso regime legal, ditado pelo artigo 144 da Constituição Federal, conferir à polícia ostensiva o atributo militar significa obrigá-la a organizar-se à semelhança do exército, do qual ela é considerada força reserva. Sabe-se que o melhor formato organizacional é aquele que melhor serve às finalidades da instituição. Não há um formato ideal em abstrato. A forma mais adequada de organização de uma universidade é diferente daquela que melhor atende às necessidades de um supermercado, um partido político ou uma empresa de comunicação. Finalidades distintas exigem estruturas organizacionais diversas. Portanto, só seria racional reproduzir na polícia o formato do exército se as finalidades de ambas as instituições fossem as mesmas. Não é o que diz a Constituição, nem o que manda o bom senso. O exército destina-se a defender o território e a soberania nacional. Para cumprir essa função, precisa organizar-se para executar o “pronto emprego”, isto é, mobilizar grandes contingentes humanos e equipamentos com máxima presteza e estrita observância das ordens emanadas do comando. Necessita manter-se alerta para ações de defesa e, no limite, fazer a guerra. O “pronto emprego” requer centralização decisória, hierarquia rígida e estrutura fortemente verticalizada. Portanto, a forma da organização atende às exigências impostas pelo cumprimento do papel constitucional que cabe à instituição. Nada disso se verifica na polícia militar. Sua função é garantir os direitos dos cidadãos, prevenindo e reprimindo violações, recorrendo ao uso comedido e proporcional da força. Segurança é um bem público que deve ser oferecido universalmente e com equidade pelos profissionais encarregados de prestar esse serviço à cidadania. Os confrontos de tipo quase-bélico correspondem às únicas situações em que alguma semelhança poderia ser identificada com o exército, ainda que mesmo aí haja diferenças significativas. De todo modo, os confrontos equivalem a uma quantidade proporcionalmente diminuta das atividades que envolvem as PMs. Não faria sentido impor a toda a instituição um modelo organizacional adequado a atender um número relativamente pequeno de suas atribuições. A imensa maioria dos desafios enfrentados pela polícia ostensiva é melhor resolvida com a aplicação de estratégias que são praticamente inviáveis na estrutura militar. A referência a que aqui se alude é o policiamento comunitário (os nomes variam conforme o país). Essa metodologia nada tem a ver com o “pronto emprego” e implica o seguinte: o policial na rua não se restringe a cumprir ordens, fazendo ronda de vigilância ou patrulhamento determinado pelo Estado-maior da corporação, em busca de prisões em flagrante. Ele ou ela é o profissional responsável por agir como o gestor local da segurança pública, o que significa, graças a uma educação interdisciplinar e altamente qualificada: (1) diagnosticar os problemas e identificar as prioridades, em diálogo com a comunidade mas sem reproduzir seus preconceitos; (2) planejar ações, mobilizando iniciativas multissetoriais do poder público, na perspectivas de prevenir e contando com o auxílio da comunidade, o que se obtém respeitando-a. Para que atue como gestor, é indispensável valorizar o(a) profissional que atua na ponta, dotando-o de meios de comunicação para convocar apoio e de autoridade para decidir. Há sempre supervisão e interconexão, mas sobretudo autonomia para atuação criativa e adaptação plástica a circunstâncias que tendem a ser específicas aos locais e aos momentos. Esse profissional dialoga, evita a judicialização quando pertinente, media conflitos, orienta-se pela prevenção e busca acima de tudo garantir os direitos dos cidadãos. Dependendo do tipo de problema, mais importante do que uma prisão, e uma abordagem depois que o mal já foi feito, pode ser iluminar e limpar uma praça, e estimular sua ocupação pela comunidade e pelo poder público, via secretarias de cultura e esportes, por exemplo. Esse o espírito do trabalho preventivo a serviço dos cidadãos, garantindo direitos. Esse o método que já se provou superior. Mas tudo isso requer uma organização horizontal, descentralizada e flexível. Justamente o inverso da estrutura militar.</p><p>Nesse sentido, desmilitarizar significa libertar a polícia da obrigação de imitar a centralização organizacional do exército, assumindo a especificidade de sua função: promover com equidade e na medida de suas possibilidades e limitações, a garantia dos direitos dos cidadãos e das cidadãs. As implicações desta mudança alcançam diversas dimensões, como aquelas indicadas pelos que postulam a desmilitarização a partir de considerações não-organizacionais.</p>'
)

Vocabulary.where(title: 'Descentralização federativa').first_or_create(cycle: seg_publica_cycle,
  description: '<p>Os Estados podem ser unitários ou federados. Segundo a Constituição, em seu artigo 18, “a organização político-administrativa da República Federativa do Brasil compreende a União, os Estados, o Distrito Federal e os Municípios, todos autônomos, nos termos desta Constituição”. Os entes federados estão indissoluvelmente ligados entre si e submetidos em comum aos ditames constitucionais, em cujos termos se estabelece o Estado democrático de direito. Portanto, a autonomia referida é relativa, havendo entretanto espaço para sua ampliação ou redução, conforme a matéria e a capacidade política de negociação envolvida nos movimentos de cada ator, respeitadas as limitações permanentes que representam cláusulas pétreas. Desse modo, são legítimas propostas de emenda constitucional que envolvam a transferência aos estados da autoridade para definir de acordo com sua realidade, e a vontade da sociedade local, o modelo de polícia mais adequado, fixando-o na Constituição estadual, desde que sejam cumpridas as determinações expressas na Constituição Federal, as quais afirmam o que são polícias, quais suas condições de funcionamento e quais opções poderiam estar sujeitas a decisões estaduais. Dessa forma, poder-se-ia instaurar um regime, na segurança pública, de descentralização com integração sistêmica e unidade axiológica.</p>'
)

Vocabulary.where(title: 'PEC').first_or_create(cycle: seg_publica_cycle,
  description: '<p>É uma proposta de emenda à Constituição para mudá-la, o que é possível sempre que o objeto da alteração não interferir ou fundamentar-se em cláusulas pétreas. A transformação do texto constitucional pode realizar-se de vários modos: reformulando seus termos, acrescentando outros, suprimindo alguns ou substituindo suas determinações. Distingue-se, portanto, a PEC, dos projetos de lei usuais, que tramitam rotineiramente nas duas casas do Congresso nacional ou nas Assembleias Legislativas dos estados e nas Câmaras Municipais. Os projetos de lei infra-constitucionais não tem a pretensão de alterar a Lei maior do país, a Carta Magna, matriz e parâmetro para a própria avaliação da pertinência ou da legitimidade das demais legislações. Por sua importância, a aprovação depende do voto de pelo menos três quintos da Câmara, em dois turnos (308 dos 513 deputados federais), e de, no mínimo, 60% do Senado (49 dos 81 senadores), também em dois turnos.</p>'
)

Vocabulary.where(title: 'PEC-51').first_or_create(cycle: seg_publica_cycle,
  description: '<p>A PEC-51 pretende promover a trasformação da arquitetura institucional da segurança pública. Suas teses principais são as seguintes:</p><p>(1) Desmilitarização: as PMs deixam de existir como tais, porque perdem o caráter militar, dado pelo vínculo orgânico com o Exército (enquanto força reserva) e pelo espelhamento organizacional. (2) Toda instituição policial passa a ordenar-se em carreira única. Hoje, na PM, há duas polícias: oficiais e praças. Na polícia civil, delegados e não-delegados. (3) Toda polícia deve realizar o ciclo completo do trabalho policial (preventivo, ostensivo, investigativo). Sepulta-se, assim, a divisão do ciclo do trabalho policial entre militares e civis. Por obstar a eficiência e minar a cooperação, sua permanência é contestada por 70% dos profissionais da segurança em todo o país. (4) A decisão sobre o formato das polícias operando nos estados (e nos municípios) cabe aos Estados. O Brasil é diverso e o federalismo deve ser observado. O Amazonas não requer o mesmo modelo policial adequado a São Paulo, por exemplo. Uma camisa-de-força nacional choca-se com as diferenças entre as regiões. (5) A escolha dos Estados restringe-se ao repertório estabelecido na Constituição –pela PEC--, o qual se define a partir de dois critérios e suas combinações: territorial e criminal, isto é, as polícias se organizarão segundo tipos criminais e/ou circunscrições espaciais. Por exemplo: um estado poderia criar polícias (sempre de ciclo completo) municipais nos maiores municípios, as quais focalizariam os crimes de pequeno potencial ofensivo (previstos na Lei 9.099); uma polícia estadual dedicada a prevenir e investigar a criminalidade correspondente aos demais tipos penais, salvo onde não houvesse polícia municipal; e uma polícia estadual destinada a trabalhar exclusivamente contra o crime organizado. Há muitas outras possibilidades autorizadas pela PEC, evidentemente, porque são vários os formatos que derivam da combinação dos critérios referidos. (6) A depender das decisões estaduais, os municípios poderão, portanto, assumir novas e amplas responsabilidades na segurança pública. A própria municipalização integral poder-se-ia dar, no estado que assim decidisse. O artigo 144 da Constituição, atualmente vigente, é omisso em relação ao Município, suscitando um desenho que contrasta com o que ocorre em todas as outras políticas sociais. Na educação, na saúde e na assistência social, o município tem se tornado agente de grande importância, articulado a sistemas integrados, os quais envolvem as distintas esferas, distribuindo responsabilidades de modo complementar. O artigo 144, hoje, autoriza a criação de guarda municipal, entendendo-a como corpo de vigias dos “próprios municipais”, não como ator da segurança pública. As guardas civis têm se multiplicado no país por iniciativa ad hoc de prefeitos, atendendo à demanda popular, mas sua constitucionalidade é discutível e, sobretudo, não seguem uma política nacional sistêmica e integrada, sob diretrizes claras. O resultado é que acabam se convertendo em pequenas PMs em desvio de função, repetindo vícios da matriz copiada. Perde-se, assim, uma oportunidade histórica de inventar instituições policiais de novo tipo, antecipando o futuro e o gestando, em vez de reproduzir equívocos do passado. (7) As responsabilidades da União são expandidas na educação, assumindo a atribuição de supervisionar e regulamentar a formação policial, respeitando diferenças institucionais, regionais e de especialidades, mas garantindo uma base comum e afinada com as finalidades afirmadas na Constituição. Hoje, a formação policial é uma verdadeira babel. (8) A PEC propõe avanços também no controle externo e na participação da sociedade, o que é decisivo para alterar o padrão de relacionamento das instituições policiais com as populações mais vulneráveis, atualmente marcado pela hostilidade, a qual reproduz desigualdades. (9) Os direitos trabalhistas dos profissionais da segurança serão plenamente respeitados durante as mudanças. A intenção é que todos os policiais sejam mais valorizados pelos governos, por suas instituições e pela sociedade. (10) A transição prevista será prudente, metódica, gradual e rigorosamente planejada, assim como transparente, envolvendo a participação da sociedade.</p>'
)

Vocabulary.where(title: 'PEC-51 Integral').first_or_create(cycle: seg_publica_cycle,
  description: '<p><strong>PROPOSTA DE EMENDA &Agrave; CONSTITUI&Ccedil;&Atilde;O N&ordm; __, DE __ DE SETEMBRO DE 2013</strong></p>
<p><span style="font-weight: 400;">Altera os arts. 21, 24 e 144 da Constitui&ccedil;&atilde;o; acrescenta os arts. 143-A, 144-A e 144-B, reestrutura o modelo de seguran&ccedil;a p&uacute;blica a partir da desmilitariza&ccedil;&atilde;o do modelo policial.</span></p>
<p><span style="font-weight: 400;">As Mesas da C&acirc;mara dos Deputados e do Senado Federal, nos termos do &sect; 3&ordm; do art. 60 da Constitui&ccedil;&atilde;o Federal, promulgam a seguinte Emenda ao texto constitucional:</span></p>
<p><strong>Art. 1&ordm;</strong><span style="font-weight: 400;"> O art. 21 da Constitui&ccedil;&atilde;o passa a vigorar acrescido dos seguintes incisos XXVI e XXVII; o inciso XVI do art. 24 passa a vigorar com a seguinte reda&ccedil;&atilde;o, acrescendo-se o inciso XVII:</span></p>
<p><span style="font-weight: 400;">&ldquo;Art. 21.........................................................................................................</span></p>
<p><span style="font-weight: 400;">.................................................................................................................................</span></p>
<p><span style="font-weight: 400;">XXVI &ndash; estabelecer princ&iacute;pios e diretrizes para a seguran&ccedil;a p&uacute;blica, inclusive quanto &agrave; produ&ccedil;&atilde;o de dados criminais e prisionais, &agrave; gest&atilde;o do conhecimento e &agrave; forma&ccedil;&atilde;o dos profissionais, e para a cria&ccedil;&atilde;o e o funcionamento, nos &oacute;rg&atilde;os de seguran&ccedil;a p&uacute;blica, de mecanismos de participa&ccedil;&atilde;o social e promo&ccedil;&atilde;o da transpar&ecirc;ncia; e</span></p>
<p><span style="font-weight: 400;">XXVII &ndash; apoiar os Estados e munic&iacute;pios na provis&atilde;o da seguran&ccedil;a p&uacute;blica&rdquo;.</span></p>
<p><span style="font-weight: 400;">&ldquo;Art. 24........................................................................................................</span></p>
<p><span style="font-weight: 400;">.................................................................................................................................</span></p>
<p><span style="font-weight: 400;">XVI &ndash; organiza&ccedil;&atilde;o dos &oacute;rg&atilde;os de seguran&ccedil;a p&uacute;blica; e</span></p>
<p><span style="font-weight: 400;">XVII &ndash; garantias, direitos e deveres dos servidores da seguran&ccedil;a p&uacute;blica&rdquo; (NR).</span></p>
<p><strong>Art. 2&ordm;</strong><span style="font-weight: 400;"> A Constitui&ccedil;&atilde;o passa a vigorar acrescida do seguinte art. 143-A, ao Cap&iacute;tulo III &ndash; Da Seguran&ccedil;a P&uacute;blica:</span></p>
<p><span style="font-weight: 400;">&ldquo;CAP&Iacute;TULO III</span></p>
<p><span style="font-weight: 400;">DA SEGURAN&Ccedil;A P&Uacute;BLICA</span></p>
<p><span style="font-weight: 400;">Art. 143-A. A seguran&ccedil;a p&uacute;blica, dever do Estado, direito e responsabilidade de todos, &eacute; exercida para a preserva&ccedil;&atilde;o da ordem p&uacute;blica democr&aacute;tica e para a garantia dos direitos dos cidad&atilde;os, inclusive a incolumidade das pessoas e do patrim&ocirc;nio, observados os seguintes princ&iacute;pios:</span></p>
<p><span style="font-weight: 400;">I - atua&ccedil;&atilde;o ison&ocirc;mica em rela&ccedil;&atilde;o a todos os cidad&atilde;os, inclusive quanto &agrave; distribui&ccedil;&atilde;o espacial da provis&atilde;o de seguran&ccedil;a p&uacute;blica;</span></p>
<p><span style="font-weight: 400;">II - valoriza&ccedil;&atilde;o de estrat&eacute;gias de preven&ccedil;&atilde;o do crime e da viol&ecirc;ncia;</span></p>
<p><span style="font-weight: 400;">III - valoriza&ccedil;&atilde;o dos profissionais da seguran&ccedil;a p&uacute;blica;</span></p>
<p><span style="font-weight: 400;">IV &ndash; garantia de funcionamento de mecanismos controle social e de promo&ccedil;&atilde;o da transpar&ecirc;ncia; e</span></p>
<p><span style="font-weight: 400;">V &ndash; preven&ccedil;&atilde;o e fiscaliza&ccedil;&atilde;o efetivas de abusos e il&iacute;citos cometidos por profissionais de seguran&ccedil;a p&uacute;blica.</span></p>
<p><span style="font-weight: 400;">Par&aacute;grafo &uacute;nico. A fim de prover seguran&ccedil;a p&uacute;blica, o Estado dever&aacute; organizar pol&iacute;cias, &oacute;rg&atilde;os de natureza civil, cuja fun&ccedil;&atilde;o &eacute; garantir os direitos dos cidad&atilde;os, e que poder&atilde;o recorrer ao uso comedido da for&ccedil;a, segundo a proporcionalidade e a razoabilidade, devendo atuar ostensiva e preventivamente, investigando e realizando a persecu&ccedil;&atilde;o criminal&rdquo;.</span></p>
<p><strong>Art. 3&ordm;</strong><span style="font-weight: 400;"> O Art. 144 da Constitui&ccedil;&atilde;o passa a vigorar com a seguinte reda&ccedil;&atilde;o:</span></p>
<p><span style="font-weight: 400;">&ldquo;Art. 144. A seguran&ccedil;a p&uacute;blica ser&aacute; provida, no &acirc;mbito da Uni&atilde;o, por meio dos seguintes &oacute;rg&atilde;os, al&eacute;m daqueles previstos em lei:</span></p>
<p><span style="font-weight: 400;">I - pol&iacute;cia federal;</span></p>
<p><span style="font-weight: 400;">II - pol&iacute;cia rodovi&aacute;ria federal; e</span></p>
<p><span style="font-weight: 400;">III - pol&iacute;cia ferrovi&aacute;ria federal.</span></p>
<ul>
<li><span style="font-weight: 400;"> 1&ordm; A pol&iacute;cia federal, institu&iacute;da por lei como &oacute;rg&atilde;o permanente, organizado e mantido pela Uni&atilde;o e estruturado em carreira &uacute;nica, destina-se a:</span></li>
</ul>
<p><span style="font-weight: 400;">......................................................................................................................</span></p>
<ul>
<li><span style="font-weight: 400;"> 2&ordm; A pol&iacute;cia rodovi&aacute;ria federal, &oacute;rg&atilde;o permanente, organizado e mantido pela Uni&atilde;o e estruturado em carreira &uacute;nica, destina-se, na forma da lei, ao patrulhamento ostensivo das rodovias federais.</span></li>
<li><span style="font-weight: 400;"> 3&ordm; A pol&iacute;cia ferrovi&aacute;ria federal, &oacute;rg&atilde;o permanente, organizado e mantido pela Uni&atilde;o e estruturado em carreira &uacute;nica, destina-se, na forma da lei, ao patrulhamento ostensivo das ferrovias federais.</span></li>
<li><span style="font-weight: 400;"> 4&ordm; A lei disciplinar&aacute; a organiza&ccedil;&atilde;o e o funcionamento dos &oacute;rg&atilde;os respons&aacute;veis pela seguran&ccedil;a p&uacute;blica, de maneira a garantir a efici&ecirc;ncia de suas atividades.</span></li>
<li><span style="font-weight: 400;"> 5&ordm; A remunera&ccedil;&atilde;o dos servidores policiais integrantes dos &oacute;rg&atilde;os relacionados neste artigo e nos arts. 144-A e 144-B ser&aacute; fixada na forma do &sect; 4&ordm; do art. 39.</span></li>
<li><span style="font-weight: 400;"> 6&ordm; No exerc&iacute;cio da atribui&ccedil;&atilde;o prevista no art. 21, XXVI, a Uni&atilde;o dever&aacute; avaliar e autorizar o funcionamento e estabelecer par&acirc;metros para institui&ccedil;&otilde;es de ensino que realizem a forma&ccedil;&atilde;o de profissionais de seguran&ccedil;a p&uacute;blica&rdquo; (NR).</span></li>
</ul>
<p><strong>Art. 4&ordm;</strong><span style="font-weight: 400;"> A Constitui&ccedil;&atilde;o passa a vigorar acrescida dos seguintes arts. 144-A e 144-B:</span></p>
<p><span style="font-weight: 400;">&ldquo;Art. 144-A. A seguran&ccedil;a p&uacute;blica ser&aacute; provida, no &acirc;mbito dos Estados e Distrito Federal e dos munic&iacute;pios, por meio de pol&iacute;cias e corpos de bombeiros.</span></p>
<ul>
<li><span style="font-weight: 400;"> 1&ordm; Todo &oacute;rg&atilde;o policial dever&aacute; se organizar em ciclo completo, responsabilizando-se cumulativamente pelas tarefas ostensivas, preventivas, investigativas e de persecu&ccedil;&atilde;o criminal.</span></li>
<li><span style="font-weight: 400;"> 2&ordm; Todo &oacute;rg&atilde;o policial dever&aacute; se organizar por carreira &uacute;nica.</span></li>
<li><span style="font-weight: 400;"> 3&ordm; Os Estados e o Distrito Federal ter&atilde;o autonomia para estruturar seus &oacute;rg&atilde;os de seguran&ccedil;a p&uacute;blica, inclusive quanto &agrave; defini&ccedil;&atilde;o da responsabilidade do munic&iacute;pio, observado o disposto nesta Constitui&ccedil;&atilde;o, podendo organizar suas pol&iacute;cias a partir da defini&ccedil;&atilde;o de responsabilidades sobre territ&oacute;rios ou sobre infra&ccedil;&otilde;es penais.</span></li>
<li><span style="font-weight: 400;"> 4&ordm; Conforme o caso, as pol&iacute;cias estaduais, os corpos de bombeiros, as pol&iacute;cias metropolitanas e as pol&iacute;cias regionais subordinam-se aos Governadores dos Estados, do Distrito Federal e dos Territ&oacute;rios; as pol&iacute;cias municipais e as pol&iacute;cias submunicipais subordinam-se ao Prefeito do munic&iacute;pio.</span></li>
<li><span style="font-weight: 400;"> 5&ordm; Aos corpos de bombeiros, al&eacute;m das atribui&ccedil;&otilde;es definidas em lei, incumbe a execu&ccedil;&atilde;o de atividades de defesa civil&rdquo;.</span></li>
</ul>
<p><span style="font-weight: 400;">&ldquo;Art. 144-B. O controle externo da atividade policial ser&aacute; exercido, paralelamente ao disposto no art. 129, VII, por meio de Ouvidoria Externa, constitu&iacute;da no &acirc;mbito de cada &oacute;rg&atilde;o policial previsto nos arts. 144 e 144-A, dotada de autonomia or&ccedil;ament&aacute;ria e funcional, incumbida do controle da atua&ccedil;&atilde;o do &oacute;rg&atilde;o policial e do cumprimento dos deveres funcionais de seus profissionais e das seguintes atribui&ccedil;&otilde;es, al&eacute;m daquelas previstas em lei:</span></p>
<p><span style="font-weight: 400;">I &ndash; requisitar esclarecimentos do &oacute;rg&atilde;o policial e dos demais &oacute;rg&atilde;os de seguran&ccedil;a p&uacute;blica;</span></p>
<p><span style="font-weight: 400;">II &ndash; avaliar a atua&ccedil;&atilde;o do &oacute;rg&atilde;o policial, propondo provid&ecirc;ncias administrativas ou medidas necess&aacute;rias ao aperfei&ccedil;oamento de suas atividades;</span></p>
<p><span style="font-weight: 400;">III &ndash; zelar pela integra&ccedil;&atilde;o e compartilhamento de informa&ccedil;&otilde;es entre os &oacute;rg&atilde;os de seguran&ccedil;a p&uacute;blica e pela &ecirc;nfase no car&aacute;ter preventivo da atividade policial;</span></p>
<p><span style="font-weight: 400;">IV &ndash; suspender a pr&aacute;tica, pelo &oacute;rg&atilde;o policial, de procedimentos comprovadamente incompat&iacute;veis com uma atua&ccedil;&atilde;o humanizada e democr&aacute;tica dos &oacute;rg&atilde;os policiais;</span></p>
<p><span style="font-weight: 400;">V &ndash; receber e conhecer das reclama&ccedil;&otilde;es contra profissionais integrantes do &oacute;rg&atilde;o policial, sem preju&iacute;zo da compet&ecirc;ncia disciplinar e correcional das inst&acirc;ncias internas, podendo aplicar san&ccedil;&otilde;es administrativas, inclusive a remo&ccedil;&atilde;o, a disponibilidade ou a demiss&atilde;o do cargo, assegurada ampla defesa;</span></p>
<p><span style="font-weight: 400;">VI &ndash; representar ao Minist&eacute;rio P&uacute;blico, no caso de crime contra a administra&ccedil;&atilde;o p&uacute;blica ou de abuso de autoridade; e</span></p>
<p><span style="font-weight: 400;">VII &ndash; elaborar anualmente relat&oacute;rio sobre a situa&ccedil;&atilde;o da seguran&ccedil;a p&uacute;blica em sua regi&atilde;o, a atua&ccedil;&atilde;o do &oacute;rg&atilde;o policial de sua compet&ecirc;ncia e dos demais &oacute;rg&atilde;os de seguran&ccedil;a p&uacute;blica, bem como sobre as atividades que desenvolver, incluindo as den&uacute;ncias recebidas e as decis&otilde;es proferidas.</span></p>
<p><span style="font-weight: 400;">Par&aacute;grafo &uacute;nico. A Ouvidoria Externa ser&aacute; dirigida por Ouvidor-Geral, nomeado, entre cidad&atilde;os de reputa&ccedil;&atilde;o ilibada e not&oacute;ria atua&ccedil;&atilde;o na &aacute;rea de seguran&ccedil;a p&uacute;blica, n&atilde;o integrante de carreira policial, para mandato de 02 (dois) anos, vedada qualquer recondu&ccedil;&atilde;o, pelo Governador do Estado ou do Distrito Federal, ou pelo Prefeito do munic&iacute;pio, conforme o caso, a partir de consulta p&uacute;blica, garantida a participa&ccedil;&atilde;o da sociedade civil inclusive na apresenta&ccedil;&atilde;o de candidaturas, nos termos da lei&rdquo;.</span></p>
<p><strong>Art. 5&ordm;</strong><span style="font-weight: 400;"> Ficam preservados todos os direitos, inclusive aqueles de car&aacute;ter remunerat&oacute;rio e previdenci&aacute;rio, dos profissionais de seguran&ccedil;a p&uacute;blica, civis ou militares, integrantes dos &oacute;rg&atilde;os de seguran&ccedil;a p&uacute;blica objeto da presente Emenda &agrave; Constitui&ccedil;&atilde;o &agrave; &eacute;poca de sua promulga&ccedil;&atilde;o.</span></p>
<p><strong>Art. 6&ordm;</strong><span style="font-weight: 400;"> O munic&iacute;pio poder&aacute;, observado o disposto no art. 144-A da Constitui&ccedil;&atilde;o, converter sua guarda municipal, constitu&iacute;da at&eacute; a data de promulga&ccedil;&atilde;o da presente Emenda &agrave; Constitui&ccedil;&atilde;o, em pol&iacute;cia municipal, mediante ampla reestrutura&ccedil;&atilde;o e adequado processo de qualifica&ccedil;&atilde;o de seus profissionais, conforme par&acirc;metros estabelecidos em lei.</span></p>
<p><strong>Art. 7&ordm; </strong><span style="font-weight: 400;">O Estado ou Distrito Federal poder&aacute;, na estrutura&ccedil;&atilde;o de que trata o &sect; 3&ordm; do art. 144-A da Constitui&ccedil;&atilde;o, definir a responsabilidade das pol&iacute;cias:</span></p>
<p><span style="font-weight: 400;">I &ndash; sobre o territ&oacute;rio, considerando a divis&atilde;o de atribui&ccedil;&otilde;es pelo conjunto do Estado, regi&otilde;es metropolitanas, outras regi&otilde;es do Estado, munic&iacute;pios ou &aacute;reas submunicipais; e</span></p>
<p><span style="font-weight: 400;">II &ndash; sobre grupos de infra&ccedil;&atilde;o penal, tais como infra&ccedil;&otilde;es de menor potencial ofensivo ou crimes praticados por organiza&ccedil;&otilde;es criminosas, sendo vedada a repeti&ccedil;&atilde;o de infra&ccedil;&otilde;es penais entre as pol&iacute;cias.</span></p>
<p><strong>Art. 8&ordm; </strong><span style="font-weight: 400;">Os servidores integrantes dos &oacute;rg&atilde;os que forem objeto da exig&ecirc;ncia de carreira &uacute;nica, prevista na presente Emenda &agrave; Constitui&ccedil;&atilde;o, poder&atilde;o ingressar na referida carreira, mediante concurso interno de provas e t&iacute;tulos, na forma da lei.</span></p>
<p><strong>Art. 9&ordm;</strong><span style="font-weight: 400;"> A Uni&atilde;o, os Estados e o Distrito Federal e os munic&iacute;pios ter&atilde;o o prazo de m&aacute;ximo de seis anos para implementar o disposto na presente Emenda &agrave; Constitui&ccedil;&atilde;o.</span></p>
<p><strong>Art. 10</strong><span style="font-weight: 400;"> Esta Emenda &agrave; Constitui&ccedil;&atilde;o entra em vigor na data de sua publica&ccedil;&atilde;o.</span></p>
<p><strong>JUSTIFICATIVA</strong></p>
<ol>
<li><span style="font-weight: 400;">A seguran&ccedil;a p&uacute;blica vive uma crise permanente. Os dados s&atilde;o estarrecedores</span><span style="font-weight: 400;"> e marcados pelo signo da desigualdade, em detrimento dos grupos sociais mais vulner&aacute;veis. Nas &uacute;ltimas d&eacute;cadas o Brasil mudou, mas o campo da seguran&ccedil;a p&uacute;blica permaneceu congelado no tempo, prisioneiro da heran&ccedil;a legada pela ditadura. N&atilde;o obstante alguns ineg&aacute;veis avan&ccedil;os, mantemos ainda nossos p&eacute;s no p&acirc;ntano das execu&ccedil;&otilde;es extrajudiciais, da tortura, da trai&ccedil;&atilde;o aos direitos humanos e da aplica&ccedil;&atilde;o seletiva das leis.</span></li>
</ol>
<ol start="2">
<li><span style="font-weight: 400;">Os Estados que se disp&otilde;em a mudar e modernizar-se, valorizando os policiais, transformando e democratizando as rela&ccedil;&otilde;es das institui&ccedil;&otilde;es com a sociedade, n&atilde;o conseguem ir al&eacute;m de alguns passos t&iacute;midos, porque a Constitui&ccedil;&atilde;o federal imp&ocirc;s um formato &uacute;nico, inflex&iacute;vel, reconhecidamente ineficaz e irracional.</span></li>
</ol>
<ol start="3">
<li><span style="font-weight: 400;">Assim, os v&iacute;cios da arquitetura constitucional da seguran&ccedil;a p&uacute;blica contribuem para o quadro calamitoso dessa &aacute;rea no Pa&iacute;s. </span><strong>O ciclo da atividade policial &eacute; fracionado</strong><span style="font-weight: 400;"> &ndash; as tarefas de policiamento ostensivo, prevenindo delitos, e de investiga&ccedil;&atilde;o de crimes s&atilde;o distribu&iacute;das a &oacute;rg&atilde;os diferentes</span><span style="font-weight: 400;">. </span><strong>A fun&ccedil;&atilde;o de policiar as ruas &eacute; exclusiva de uma estrutura militarizada, for&ccedil;a de reserva do Ex&eacute;rcito - a Pol&iacute;cia Militar</strong><span style="font-weight: 400;"> -, formada, treinada e organizada para combater o inimigo, e n&atilde;o para proteger o cidad&atilde;o. A Uni&atilde;o tem responsabilidades diminutas, salvo em situa&ccedil;&otilde;es excepcionais; o munic&iacute;pio - ente federado crescentemente relevante nas demais pol&iacute;cias sociais (como educa&ccedil;&atilde;o, sa&uacute;de e assist&ecirc;ncia social) - &eacute; praticamente esquecido e os Estados concentram a maior carga de responsabilidades.</span></li>
</ol>
<ol start="4">
<li><span style="font-weight: 400;">A solu&ccedil;&atilde;o aqui proposta, de profunda refunda&ccedil;&atilde;o do sistema de seguran&ccedil;a p&uacute;blica, e do modelo policial em particular, busca a </span><strong>redefini&ccedil;&atilde;o do papel das pol&iacute;cias</strong><strong> e</strong> <strong>das responsabilidades federativas nesta &aacute;rea</strong><span style="font-weight: 400;">, a partir da </span><strong>transfer&ecirc;ncia aos Estados da autoridade para definir o modelo policial</strong><span style="font-weight: 400;">. Mas o faz sem descuidar de algumas</span> <strong>diretrizes fundamentais</strong><span style="font-weight: 400;">, </span><strong>consagradas por importantes refer&ecirc;ncias nessa &aacute;rea</strong><span style="font-weight: 400;">, para a garantia de uma </span><strong>transforma&ccedil;&atilde;o verdadeiramente democr&aacute;tica das pol&iacute;cias</strong><span style="font-weight: 400;">, e evitando o risco de descoordena&ccedil;&atilde;o e desarticula&ccedil;&atilde;o:</span></li>
</ol>
<ol>
<li style="font-weight: 400;"><strong>Desmilitariza&ccedil;&atilde;o das pol&iacute;cias</strong><strong>: </strong><span style="font-weight: 400;">implica reestrutura&ccedil;&atilde;o profunda da institui&ccedil;&atilde;o policial, no caso, da atual Pol&iacute;cia Militar, reorganizando-a, seja quanto &agrave; divis&atilde;o interna de fun&ccedil;&otilde;es, seja na forma&ccedil;&atilde;o e treinamento dos policiais, seja nas normas que regem seu trabalho, para transformar radicalmente o padr&atilde;o de atua&ccedil;&atilde;o da institui&ccedil;&atilde;o. Sem preju&iacute;zo da hierarquia inerente a qualquer organiza&ccedil;&atilde;o, a excessiva rigidez das Pol&iacute;cias Militares deve ser substitu&iacute;da por maior autonomia para o policial, acompanhada de maior controle social e transpar&ecirc;ncia. O policial deve se relacionar com a sociedade a fim de se tornar um microgestor confi&aacute;vel da seguran&ccedil;a p&uacute;blica naquele territ&oacute;rio, responsivo e perme&aacute;vel &agrave;s demandas dos cidad&atilde;os. Esta transforma&ccedil;&atilde;o, evidentemente, deve ser acompanhada de valoriza&ccedil;&atilde;o destes profissionais, inclusive remunerat&oacute;ria.</span></li>
<li style="font-weight: 400;"><strong>Exig&ecirc;ncia de ciclo completo</strong><span style="font-weight: 400;">: a autonomia para os Estados definirem seu modelo policial n&atilde;o implica a faculdade de fracionar a atividade ostensivo/preventiva (hoje atribu&iacute;da &agrave;s Pol&iacute;cias Militares) da atividade investigativa (hoje atribu&iacute;da &agrave;s Pol&iacute;cias Civis). Necessariamente, toda institui&ccedil;&atilde;o policial deve ter car&aacute;ter ostensivo e investigativo. A diferencia&ccedil;&atilde;o de atribui&ccedil;&otilde;es deve se dar n&atilde;o em rela&ccedil;&atilde;o &agrave;s fases do ciclo policial, mas sobre o territ&oacute;rio ou sobre grupos de infra&ccedil;&otilde;es penais (para maior clareza quanto &agrave;s op&ccedil;&otilde;es &agrave; disposi&ccedil;&atilde;o do Estado, vide a partir do item 8, </span><em><span style="font-weight: 400;">infra</span></em><span style="font-weight: 400;">).</span></li>
<li style="font-weight: 400;"><strong>Defini&ccedil;&atilde;o constitucional de pol&iacute;cia</strong><span style="font-weight: 400;">: a pol&iacute;cia &eacute; definida como institui&ccedil;&atilde;o de natureza civil que se destina a proteger os direitos dos cidad&atilde;os e a preservar a ordem p&uacute;blica democr&aacute;tica, a partir do uso comedido e proporcional da for&ccedil;a. Esta defini&ccedil;&atilde;o supre lacuna da Constitui&ccedil;&atilde;o, e constitui a pedra angular de um sistema de seguran&ccedil;a p&uacute;blica democr&aacute;tico e garantidor das liberdades p&uacute;blicas. Ademais, a proposta fixa princ&iacute;pios fundamentais que dever&atilde;o reger a seguran&ccedil;a p&uacute;blica.</span></li>
<li style="font-weight: 400;"><strong>Valoriza&ccedil;&atilde;o do munic&iacute;pio na provis&atilde;o da seguran&ccedil;a p&uacute;blica</strong><span style="font-weight: 400;">: o munic&iacute;pio &eacute; inclu&iacute;do entre os entes respons&aacute;veis pela seguran&ccedil;a p&uacute;blica, podendo, a depender da decis&atilde;o tomada em n&iacute;vel estadual, instituir pol&iacute;cias em n&iacute;vel local (para maior clareza quanto aos modelos poss&iacute;veis para o Estado, vide a partir do item 8, </span><em><span style="font-weight: 400;">infra</span></em><span style="font-weight: 400;">).</span></li>
<li style="font-weight: 400;"><strong>Aumento da participa&ccedil;&atilde;o da Uni&atilde;o</strong><span style="font-weight: 400;">: em &aacute;reas cr&iacute;ticas para a seguran&ccedil;a p&uacute;blica, que se ressentem de maior padroniza&ccedil;&atilde;o e uniformiza&ccedil;&atilde;o em n&iacute;vel nacional, a Uni&atilde;o dever&aacute; estabelecer diretrizes gerais. &Eacute; o caso da gest&atilde;o e do compartilhamento de informa&ccedil;&otilde;es, da produ&ccedil;&atilde;o de dados criminais e prisionais, al&eacute;m da cria&ccedil;&atilde;o e funcionamento de mecanismos de controle social e promo&ccedil;&atilde;o da transpar&ecirc;ncia. Na forma&ccedil;&atilde;o policial, a Uni&atilde;o dever&aacute; avaliar e autorizar o funcionamento de institui&ccedil;&otilde;es de ensino que atuem na &aacute;rea, a fim de garantir n&iacute;veis adequados de qualidade e a conformidade a uma perspectiva democr&aacute;tica de seguran&ccedil;a p&uacute;blica.</span></li>
<li style="font-weight: 400;"><strong>Institui&ccedil;&atilde;o de mecanismos de transpar&ecirc;ncia e controle externo dos &oacute;rg&atilde;os policiais</strong><span style="font-weight: 400;">: em cada &oacute;rg&atilde;o policial dever&aacute; ser institu&iacute;da Ouvidoria Externa com autonomia funcional e administrativa, dirigida por Ouvidor-Geral com independ&ecirc;ncia e mandato fixo. A Ouvidoria ter&aacute; compet&ecirc;ncia regulamentar (para dispor sobre procedimentos de atua&ccedil;&atilde;o dos policiais, suspender a execu&ccedil;&atilde;o de procedimentos inadequados, e avaliar e monitorar suas atividades) e disciplinar (para receber e processar reclama&ccedil;&otilde;es e den&uacute;ncias contra abusos cometidos por profissionais de seguran&ccedil;a p&uacute;blica, podendo decidir, inclusive, pela demiss&atilde;o do cargo).</span></li>
<li style="font-weight: 400;"><strong>Exig&ecirc;ncia de carreira &uacute;nica por institui&ccedil;&atilde;o policial</strong><span style="font-weight: 400;">: a exist&ecirc;ncia de duplicidade de carreiras, com estatura distinta, nas diversas institui&ccedil;&otilde;es policiais, &eacute; reconhecidamente causadora de graves conflitos internos e inefici&ecirc;ncias. A proposta avan&ccedil;a ao propor a carreira &uacute;nica por institui&ccedil;&atilde;o policial. &Eacute; preciso registrar que essa medida n&atilde;o &eacute; incompat&iacute;vel com o princ&iacute;pio hier&aacute;rquico ou com o estabelecimento de grada&ccedil;&atilde;o interna &agrave; carreira, que permita a ascens&atilde;o do profissional, mediante adequada capacita&ccedil;&atilde;o e forma&ccedil;&atilde;o, a partir de instrumentos meritocr&aacute;ticos.</span></li>
</ol>
<ol start="5">
<li><span style="font-weight: 400;">Evidentemente, </span><strong>tal processo de transforma&ccedil;&atilde;o exige implementa&ccedil;&atilde;o cuidadosa, com</strong> <strong>participa&ccedil;&atilde;o e monitoramento intensos por parte da sociedade civil e rigoroso respeito aos direitos adquiridos dos profissionais de seguran&ccedil;a p&uacute;blica</strong><span style="font-weight: 400;">. Assim, nas disposi&ccedil;&otilde;es transit&oacute;rias da Emenda garantimos a preserva&ccedil;&atilde;o dos direitos, sendo a ampla participa&ccedil;&atilde;o social inerente a todo o processo.</span></li>
</ol>
<ol start="6">
<li><span style="font-weight: 400;">Resguardadas essas diretrizes fundamentais, e que garantem o potencial transformador desta proposta, os Estados dever&atilde;o decidir se promover&atilde;o o ciclo completo do trabalho policial, a desmilitariza&ccedil;&atilde;o e a carreira &uacute;nica (no &acirc;mbito de cada institui&ccedil;&atilde;o) reorganizando as institui&ccedil;&otilde;es policiais (as atuais pol&iacute;cias estaduais, a Pol&iacute;cia Civil e a Pol&iacute;cia Militar) segundo atribui&ccedil;&atilde;o de responsabilidade sobre territ&oacute;rio ou sobre grupos de infra&ccedil;&atilde;o penal.</span></li>
</ol>
<ol start="7">
<li><span style="font-weight: 400;">Esta autonomia regulada implica grande variedade de modelos &agrave; disposi&ccedil;&atilde;o dos Estados. Com isso, reconhecemos a complexidade nacional do problema, cuja fonte &eacute; a extraordin&aacute;ria diferen&ccedil;a entre regi&otilde;es, Estados e at&eacute; mesmo munic&iacute;pios da Federa&ccedil;&atilde;o brasileira.</span></li>
</ol>
<ol start="8">
<li><span style="font-weight: 400;">Passamos, assim, a descrever </span><strong>as alternativas &agrave; disposi&ccedil;&atilde;o dos Estados</strong><span style="font-weight: 400;">.</span></li>
</ol>
<ol start="9">
<li><strong>Se a refer&ecirc;ncia for o territ&oacute;rio</strong><span style="font-weight: 400;">, as novas pol&iacute;cias nos estados de ciclo completo e carreira &uacute;nica poder&atilde;o ser:</span></li>
</ol>
<ol>
<li style="font-weight: 400;"><span style="font-weight: 400;">Pol&iacute;cia Unificada Civil Estadual. Nesse caso, uma pol&iacute;cia unificada &eacute; respons&aacute;vel pela provis&atilde;o de seguran&ccedil;a p&uacute;blica a toda a popula&ccedil;&atilde;o do estado, cobrindo todo seu territ&oacute;rio, por meio do cumprimento de suas fun&ccedil;&otilde;es, envolvendo as atividades ostensivo/preventivas, investigativas e de persecu&ccedil;&atilde;o criminal.</span></li>
<li style="font-weight: 400;"><span style="font-weight: 400;">Pol&iacute;cia Metropolitana (sempre civil e de ciclo completo). Nesse caso, uma pol&iacute;cia civil de ciclo completo &eacute; respons&aacute;vel pela provis&atilde;o de seguran&ccedil;a p&uacute;blica &agrave; popula&ccedil;&atilde;o da regi&atilde;o metropolitana daquele estado. Nessa hip&oacute;tese, uma pol&iacute;cia unificada civil estadual ser&aacute; respons&aacute;vel pela provis&atilde;o de seguran&ccedil;a p&uacute;blica &agrave; popula&ccedil;&atilde;o dos munic&iacute;pios do estado em quest&atilde;o n&atilde;o atendidos pela ou pelas pol&iacute;cias metropolitanas.</span></li>
<li style="font-weight: 400;"><span style="font-weight: 400;">Pol&iacute;cia Municipal (sempre civil e de ciclo completo). Nesse caso, uma pol&iacute;cia civil de ciclo completo &eacute; respons&aacute;vel pela provis&atilde;o de seguran&ccedil;a p&uacute;blica &agrave; popula&ccedil;&atilde;o de um, de alguns ou de todos os munic&iacute;pios do estado em quest&atilde;o. O crit&eacute;rio da decis&atilde;o ser&aacute; escolhido pelo Estado. Exemplos: pode ser a escala demogr&aacute;fica (privilegiando, por exemplo, apenas a capital ou os munic&iacute;pios cujas popula&ccedil;&otilde;es excedam 500 mil habitantes, etc...), pode ser o hist&oacute;rico da criminalidade ou pode ser generalizada, aplicando-se a todos os munic&iacute;pios do Estado em pauta. A decis&atilde;o de criar pol&iacute;cia municipal envolve a defini&ccedil;&atilde;o de fonte de receita compat&iacute;vel com a magnitude das novas responsabilidades or&ccedil;ament&aacute;rias.</span></li>
<li style="font-weight: 400;"><span style="font-weight: 400;">Pol&iacute;cia Distrital ou Submunicipal ou seja, de &aacute;rea interna ao munic&iacute;pio. Nesse caso, uma pol&iacute;cia civil de ciclo completo &eacute; respons&aacute;vel pela provis&atilde;o de seguran&ccedil;a p&uacute;blica &agrave; popula&ccedil;&atilde;o de um distrito ou uma &aacute;rea interna ao munic&iacute;pio. Assim, uma cidade pode criar v&aacute;rias pol&iacute;cias locais e uma pol&iacute;cia municipal respons&aacute;vel pelas &aacute;reas n&atilde;o cobertas pelas pol&iacute;cias locais.</span></li>
</ol>
<ol start="10">
<li><span style="font-weight: 400;">As obje&ccedil;&otilde;es mais frequentes &agrave; reorganiza&ccedil;&atilde;o sobre o territ&oacute;rio diz respeito &agrave; quantidade de pol&iacute;cias. Neste particular, &eacute; preciso ressaltar que n&atilde;o &eacute; o n&uacute;mero que produz fragmenta&ccedil;&atilde;o e descoordena&ccedil;&atilde;o. Havendo diretrizes nacionais e controle de qualidade na forma&ccedil;&atilde;o dos profissionais, na gest&atilde;o do conhecimento e em outros setores, a tend&ecirc;ncia &eacute; que haja integra&ccedil;&atilde;o na multiplicidade. As virtudes de mais e menores pol&iacute;cias s&atilde;o evidentes: controle externo, transpar&ecirc;ncia, aferi&ccedil;&atilde;o da efici&ecirc;ncia, participa&ccedil;&atilde;o da sociedade, poder exemplar indutor das boas pr&aacute;ticas, via compara&ccedil;&atilde;o. Outra cr&iacute;tica comum diz respeito &agrave; suposta incompatibilidade deste modelo com a divis&atilde;o do trabalho judici&aacute;rio e sua distribui&ccedil;&atilde;o territorial (que apenas reconhece Uni&atilde;o e Estados). A cr&iacute;tica n&atilde;o procede, pois as pol&iacute;cias &ndash; Metropolitanas e Submunicipais, por exemplo &ndash; dever&atilde;o encaminhar seus procedimentos &agrave;s respectivas inst&acirc;ncias judiciais estaduais.</span></li>
</ol>
<ol start="11">
<li><strong>Se a refer&ecirc;ncia forem os grupos de infra&ccedil;&atilde;o penal</strong><span style="font-weight: 400;">, as novas pol&iacute;cias nos estados de ciclo completo e carreira &uacute;nica poder&atilde;o ser, por exemplo:</span></li>
</ol>
<ol>
<li style="font-weight: 400;"><span style="font-weight: 400;">Pol&iacute;cia Unificada Civil Estadual respons&aacute;vel por prevenir e investigar crimes de pequeno potencial ofensivo. Nesse caso, uma pol&iacute;cia unificada prov&ecirc; seguran&ccedil;a p&uacute;blica na esfera infracional em rela&ccedil;&atilde;o a toda a popula&ccedil;&atilde;o do estado, cobrindo todo seu territ&oacute;rio, por meio do cumprimento de suas fun&ccedil;&otilde;es, envolvendo as atividades ostensivo/preventivas, investigativas e de persecu&ccedil;&atilde;o criminal ou responsabiliza&ccedil;&atilde;o.</span></li>
<li style="font-weight: 400;"><span style="font-weight: 400;">Pol&iacute;cia Unificada Civil Estadual respons&aacute;vel por prevenir, investigar e dar in&iacute;cio &agrave; persecu&ccedil;&atilde;o criminal dos suspeitos de participar do crime organizado. Nesse caso, uma pol&iacute;cia unificada prov&ecirc; seguran&ccedil;a p&uacute;blica na esfera criminal referida a toda a popula&ccedil;&atilde;o do estado, cobrindo todo seu territ&oacute;rio, por meio do cumprimento de suas fun&ccedil;&otilde;es, envolvendo as atividades ostensivo/preventivas (aquelas pertinentes nos casos de crime organizado), investigativas e de persecu&ccedil;&atilde;o criminal.</span></li>
<li style="font-weight: 400;"><span style="font-weight: 400;">Pol&iacute;cia Unificada Civil Estadual respons&aacute;vel por prevenir, investigar e dar in&iacute;cio &agrave; persecu&ccedil;&atilde;o criminal dos suspeitos de participar dos demais tipos de crime. Nesse caso, uma pol&iacute;cia unificada prov&ecirc; seguran&ccedil;a p&uacute;blica na esfera criminal referida a toda a popula&ccedil;&atilde;o do estado, cobrindo todo seu territ&oacute;rio, por meio do cumprimento de suas fun&ccedil;&otilde;es, envolvendo as atividades ostensivo/preventivas, investigativas e de persecu&ccedil;&atilde;o criminal.</span></li>
</ol>
<ol start="12">
<li><span style="font-weight: 400;">Por outro lado, </span><strong>combinando-se os dois crit&eacute;rios de divis&atilde;o das atribui&ccedil;&otilde;es das pol&iacute;cias sobre o territ&oacute;rio e sobre grupos de infra&ccedil;&otilde;es penais</strong><span style="font-weight: 400;">, temos um elevado n&uacute;mero de alternativas, dentre as quais destacamos, apenas a t&iacute;tulo exemplificativo:</span></li>
</ol>
<ol>
<li style="font-weight: 400;"><span style="font-weight: 400;">Pol&iacute;cia Municipal (sempre civil e de ciclo completo) respons&aacute;vel por atuar apenas contra crimes de pequeno potencial ofensivo, em um munic&iacute;pio do Estado, em alguns deles ou em todos. </span></li>
<li style="font-weight: 400;"><span style="font-weight: 400;">Pol&iacute;cia Unificada Civil Estadual. Uma pol&iacute;cia unificada &eacute; respons&aacute;vel pela provis&atilde;o de seguran&ccedil;a p&uacute;blica a toda a popula&ccedil;&atilde;o do estado, cobrindo todo seu territ&oacute;rio, atuando contra todo tipo de criminalidade e infra&ccedil;&atilde;o, exceto os crimes de pequeno potencial ofensivo ou infra&ccedil;&otilde;es nos munic&iacute;pios onde houver uma pol&iacute;cia municipal com esta incumb&ecirc;ncia espec&iacute;fica.</span></li>
</ol>
<ol start="13">
<li><strong>Por que adotar um modelo federativo e diversificado, aberto ao experimentalismo e &agrave; pluralidade de iniciativas? Porque as realidades regionais, estaduais e at&eacute; municipais s&atilde;o diferentes</strong><span style="font-weight: 400;">. Como adotar no Amazonas a solu&ccedil;&atilde;o organizacional que melhor serve a S&atilde;o Paulo e vice versa? Al&eacute;m disso, a ousadia criativa de um Estado pode inspirar outras unidades da federa&ccedil;&atilde;o a seguir a mesma linha ou buscar a sua pr&oacute;pria, aprendendo com erros e acertos eventualmente j&aacute; pass&iacute;veis de observa&ccedil;&atilde;o alhures.</span></li>
</ol>
<ol start="14">
<li><span style="font-weight: 400;">A diversidade ser&aacute; salutar, pois a presente proposta estabelece diretrizes fundamentais em n&iacute;vel nacional (referidas no item 4, </span><em><span style="font-weight: 400;">supra</span></em><span style="font-weight: 400;">), gra&ccedil;as &agrave;s quais a multiplicidade ser&aacute; sin&ocirc;nimo de riqueza e n&atilde;o de dispers&atilde;o e desintegra&ccedil;&atilde;o. Hoje, temos o pior dos dois mundos: uma camisa de for&ccedil;a nacional, ditada pelo artigo 144 da Constitui&ccedil;&atilde;o, e a babel na forma&ccedil;&atilde;o, na informa&ccedil;&atilde;o, na gest&atilde;o e na desej&aacute;vel e ainda invi&aacute;vel, salvo excepcionalmente, coopera&ccedil;&atilde;o e integra&ccedil;&atilde;o sist&ecirc;mica.</span></li>
</ol>
<p><span style="font-weight: 400;">15.</span> <span style="font-weight: 400;">Acreditamos oferecer uma solu&ccedil;&atilde;o de profunda reestrutura&ccedil;&atilde;o de nosso sistema de seguran&ccedil;a p&uacute;blica, para a transforma&ccedil;&atilde;o radical de nossas pol&iacute;cias. A partir da desmilitariza&ccedil;&atilde;o da Pol&iacute;cia Militar e da repactua&ccedil;&atilde;o das responsabilidades federativas na &aacute;rea, bem como da garantia do ciclo policial completo e da exig&ecirc;ncia de carreira &uacute;nica por institui&ccedil;&atilde;o policial, pretende-se criar as condi&ccedil;&otilde;es para que a provis&atilde;o da seguran&ccedil;a p&uacute;blica se d&ecirc; de forma mais humanizada e mais ison&ocirc;mica em rela&ccedil;&atilde;o a todos os cidad&atilde;os, rompendo, assim, com o quadro dram&aacute;tico da seguran&ccedil;a p&uacute;blica no Pa&iacute;s.</span></p>'
)

Subject.where(
  title: 'Ciclo Completo',
  enunciation: 'A Constituição federal estabelece que, nos estados e no Distrito Federal, o ciclo de trabalho policial seja dividido em duas partes, destinando-se uma polícia às tarefas chamadas ostensivo-preventivas e outra, às tarefas investigativas.',
  question: 'Você considera positiva esta divisão ou acha que o ciclo de trabalho policial deveria ser completo, ou seja, que a mesma polícia deveria realizar as tarefas ostensivo-preventivas e investigativas?',
  plugin_relation: plugin_relation_discussao_sp,
  tag_description: '<p>Refere-se ao conjunto de tarefas constitucionalmente atribuídas às instituições policiais, as quais envolvem a investigação criminal e o trabalho ostensivo, uniformizado, preventivo. No caso brasileiro, o modelo policial previsto pela Constituição veda que à mesma instituição policial, com exceção da Polícia Federal, seja conferida a responsabilidade de cumprir o ciclo completo.</p>',
  vocabulary: Vocabulary.find(12)
).first_or_create

Subject.where(
  title: 'Carreira Única',
  enunciation: 'Nas polícias civis e na polícia federal, é possível ingressar por meio de dois concursos públicos diferentes: para agente (investigador) ou para delegado. Desse modo, mesmo os agentes que se destacam, ou são bacharéis em direito, não podem chegar ao cargo de delegado se não participarem de concurso externo, competindo com candidatos que nunca pisaram numa delegacia. Nesta seleção, o tempo de experiência na polícia não é considerado. O mesmo acontece nas polícias militares: as praças não podem ascender a oficial, se não por um concurso externo.',
  question: 'Você concorda com esse modelo da dupla entrada, ou acha que a carreira deveria ser única em cada instituição e construída gradativamente, com seleções internas?',
  plugin_relation: plugin_relation_discussao_sp,
  tag_description: '<p>Descreve um certo tipo de trajetória profissional prescrita por cada instituição (no caso, policial) cuja característica distintiva é o ingresso único e, portanto, comum, sem prejuízo das especialidades e das ramificações de funções, assim como das hierarquizações internas, as quais dependerão, ao longo do exercício profissional, da avaliação de méritos individuais, de exames sobre a competência e de avaliações de desempenho. Nas polícias federal, civis e militares, há duas portas de entrada: uma para o cargo de delegado, outra para os demais cargos; uma para a posição de oficial; outra para praças.</p>',
  vocabulary: Vocabulary.find(13)
).first_or_create

Subject.where(
  title: 'Descentralização Federativa',
  enunciation: 'Algumas pessoas pensam que a melhor solução para a Segurança Pública no Brasil, considerando-se as enormes diferenças regionais, seria a adoção de modelos policiais diferentes em cada estado, de acordo com as características territoriais e os tipos criminais predominantes. Assim, seria possível, por exemplo, que fossem criadas polícias municipais em grandes cidades, que se combinariam com uma polícia voltada para as demais áreas do estado e com uma polícia dedicada exclusivamente a um tipo criminal específico, como o crime organizado. A PEC-51 propõe a descentralização federativa que torna possíveis arranjos deste tipo, respeitando parâmetros nacionais: a desmilitarização, o ciclo completo e a carreira única.',
  question: 'O que você acha?',
  plugin_relation: plugin_relation_discussao_sp,
  tag_description: '<p>Os Estados podem ser unitários ou federados. Segundo a Constituição, em seu artigo 18, “a organização político-administrativa da República Federativa do Brasil compreende a União, os Estados, o Distrito Federal e os Municípios, todos autônomos, nos termos desta Constituição”. Portanto, são legítimas propostas de emenda constitucional que envolvam a transferência aos estados e ao DF da autoridade para definir de acordo com sua realidade, e a vontade da sociedade local, o modelo de polícia mais adequado, desde que sejam cumpridas as determinações expressas na Constituição Federal, as quais afirmam o que são polícias, quais suas condições de funcionamento e quais opções poderiam estar sujeitas a decisões estaduais.</p>',
  vocabulary: Vocabulary.find(18)
).first_or_create

Subject.where(
  title: 'Controle da Atividade Policial',
  enunciation: 'Na democracia, as polícias são instituições que têm autoridade para usar a força, de maneira comedida, com o objetivo de garantir o respeito a direitos ameaçados. Este poder exige controle por parte da sociedade. No Brasil, hoje, o controle interno é exercido pelas corregedorias das próprias polícias. Já o controle externo é exercido pelo Ministério Público. Esses mecanismos têm se mostrado insuficientes, dada a gravidade dos problemas não resolvidos.',
  question: 'Você concorda com a criação de Ouvidorias Externas às instituições policiais, com condições para atuar com autonomia em benefício da sociedade e dos policiais?',
  plugin_relation: plugin_relation_discussao_sp,
  tag_description: '<p>Em cada órgão policial deverá ser instituída Ouvidoria Externa com autonomia funcional e administrativa, dirigida por Ouvidor-Geral com independência e mandato fixo. A Ouvidoria terá competência regulamentar (para dispor sobre procedimentos de atuação dos policiais, suspender a execução de procedimentos inadequados, e avaliar e monitorar suas atividades) e disciplinar (para receber e processar reclamações e denúncias contra abusos cometidos por profissionais de segurança pública, podendo decidir, inclusive, pela demissão do cargo).</p>'
).first_or_create

Subject.where(
  title: 'Padronização da Formação Policial',
  enunciation: 'As escolas de formação de médicos, engenheiros, bacharéis em direito e da maior parte das profissões são avaliadas regularmente por conselhos federais de educação não governamentais ou políticos. Estes conselhos têm autonomia e confiabilidade profissional para avaliar o desempenho das escolas, cobrando respeito a parâmetros previamente estabelecidos e orientando seu aperfeiçoamento. No caso da formação policial, não há parâmetros nacionais relativos a tempo de estudo, mínimo de disciplinas ou ciclo básico comum, nem avaliação sistemática ou controle de qualidade.',
  question: 'Você acha que a União deveria assumir responsabilidades quanto à formação policial como faz com a formação dos demais profissionais?',
  plugin_relation: plugin_relation_discussao_sp,
  tag_description: '<p>Em áreas críticas para a segurança pública, que se ressentem de maior padronização e uniformização em nível nacional, a União deverá estabelecer diretrizes gerais. É o caso da gestão e do compartilhamento de informações, da produção de dados criminais e prisionais, além da criação e funcionamento de mecanismos de controle social e promoção da transparência. Na formação policial, a União deverá avaliar e autorizar o funcionamento de instituições de ensino que atuem na área, a fim de garantir níveis adequados de qualidade e a conformidade a uma perspectiva democrática de segurança pública.</p>'
).first_or_create

Subject.where(
  title: 'Desmilitarização',
  enunciation: 'A Constituição determina que haja duas polícias estaduais: uma é militar, ligada ao Exército, reproduz seu modelo de organização e é encarregada das ações ostensivas e preventivas; outra é civil e responsável pelas investigações.',
  question: 'Você acha que as atuais PMs devem continuar a ser militares ou todas as polícias deveriam ser civis?',
  plugin_relation: plugin_relation_discussao_sp,
  tag_description: '<p>Em nosso regime legal, conferir à polícia ostensiva o atributo militar significa obrigá-la a organizar-se à semelhança do exército, do qual ela é considerada força reserva, e subordiná-la a dupla linha de autoridade: uma que a vincula ao executivo estadual, outra que a vincula ao comando do exército. Por isso, desmilitarizar significa anular a dependência do exército e libertar a polícia da obrigação de reproduzir o formato organizacional centralizado do exército, assumindo a especificidade de sua função policial, que não é combater o inimigo mas prestar um serviço público, promovendo, com equidade e na medida de suas possibilidades e limitações, a garantia dos direitos dos cidadãos e das cidadãs.</p>',
  vocabulary: Vocabulary.find(17)
).first_or_create

forest_file = File.new "#{Rails.root}/app/assets/images/Floresta_1.jpg", "r"

BlogPost.where(title: 'Por que Mudamos?').first_or_create(
  content: '<p><span style="font-weight: 400;">Acreditamos que mudan&ccedil;as s&atilde;o feitas de forma coletiva, colaborativa e no presente. Este projeto &eacute; uma aposta no potencial de integra&ccedil;&atilde;o e constru&ccedil;&atilde;o democr&aacute;tica por meio da internet e da tecnologia. Por isso, </span><strong>MUDAMOS</strong><span style="font-weight: 400;"> prop&otilde;e um espa&ccedil;o virtual para discutir e construir solu&ccedil;&otilde;es para desafios p&uacute;blicos de maneira aberta e participativa. Seus principais objetivos s&atilde;o:</span></p>
<ul>
<li style="font-weight: 400;"><span style="font-weight: 400;">possibilitar debates sobre temas de interesse p&uacute;blico;</span></li>
<li style="font-weight: 400;"><span style="font-weight: 400;">conectar pessoas de diversos setores da sociedade;</span></li>
<li style="font-weight: 400;"><span style="font-weight: 400;">promover um debate informado e de qualidade;</span></li>
<li style="font-weight: 400;"><span style="font-weight: 400;">estimular a constru&ccedil;&atilde;o conjunta de solu&ccedil;&otilde;es;</span></li>
<li style="font-weight: 400;"><span style="font-weight: 400;">influenciar na cria&ccedil;&atilde;o de pol&iacute;ticas p&uacute;blicas adequadas &agrave;s demandas dos cidad&atilde;os.</span></li>
</ul>
<p><span style="font-weight: 400;">Esta proposta surge para dar conta da frustra&ccedil;&atilde;o gerada pelo debate eleitoral de 2014. Nesta &eacute;poca foi poss&iacute;vel perceber que a internet n&atilde;o cumpriu a expectativa de ser um novo espa&ccedil;o p&uacute;blico onde prevalece a coopera&ccedil;&atilde;o e a&ccedil;&otilde;es comunicativas e construtivas. Em vez do debate de propostas, presenciamos um debate de ideias pr&eacute;-fabricadas, exibidas como bandeiras, sem oportunidade real de di&aacute;logo. </span></p>
<p><strong>MUDAMOS</strong><span style="font-weight: 400;"> usa a tecnologia para chamar a sociedade a construir solu&ccedil;&otilde;es para desafios p&uacute;blicos. </span><strong>MUDAMOS</strong><span style="font-weight: 400;"> n&atilde;o foi criado para competir com a democracia e com o sistema democr&aacute;tico, mas para refor&ccedil;&aacute;-lo. As contribui&ccedil;&otilde;es dadas nos debates ser&atilde;o compiladas em documentos que ser&atilde;o entregues diretamente aos agentes p&uacute;blicos respons&aacute;veis por sua implementa&ccedil;&atilde;o. </span></p>
<p><span style="font-weight: 400;">Nossa equipe tamb&eacute;m participou da constru&ccedil;&atilde;o do Marco Civil da Internet, a lei que regula direitos e deveres na internet brasileira. O Marco Civil &eacute; reconhecido mundialmente como um dos casos mais importantes e bem sucedidos de constru&ccedil;&atilde;o coletiva de uma legisla&ccedil;&atilde;o t&atilde;o complexa. </span></p>
<p><strong>Transpar&ecirc;ncia e Seguran&ccedil;a</strong></p>
<p><span style="font-weight: 400;">Para garantir que o debate dentro da plataforma seja transparente e acess&iacute;vel, todas as discuss&otilde;es s&atilde;o abertas e ficam dispon&iacute;veis para consulta. Todo o processo &eacute; acompanhado de perto por um </span><a href="/blog/comite-de-transparencia"><strong>Comit&ecirc; de Transpar&ecirc;ncia </strong><span style="font-weight: 400;"></a> e um </span><a href="/blog/comite-de-transparencia"><strong>Ombudsperson</strong></a><span style="font-weight: 400;">.</span></p>
<p><span style="font-weight: 400;">Para promover um ambiente seguro para o usu&aacute;rio, os dados pessoais dos inscritos s&atilde;o criptografados e ser&atilde;o tratados de acordo com nossos Termos de Uso.</span></p>
<p><span style="font-weight: 400;">Conhe&ccedil;a nossos </span><a href="/termos-de-uso"><strong>Termos de Uso</strong></a><span style="font-weight: 400;"> e </span><a href="/politica-de-privacidade"><strong>Pol&iacute;tica de Privacidade</strong></a><span style="font-weight: 400;">. &nbsp;</span></p>',
  picture: 'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/Floresta_1.jpg',
  release_date: Time.zone.now,
  slug: 'por-que-mudamos'
  # plugin_relation: plugin_relation_blog_sp
)




# comite_file = File.new "#{Rails.root}/app/assets/images/conselho3.png", "r"

BlogPost.where(title: 'Comitê de Transparência e Ombudsperson').first_or_create(
  content: '<p dir="ltr"><strong>Comit&ecirc; de Transpar&ecirc;ncia e Ombudsman</strong></p>
<p dir="ltr"><strong>MUDAMOS</strong> conta com um Comit&ecirc; externo para garantir a transpar&ecirc;ncia dos nossos processos. &Eacute; um &oacute;rg&atilde;o aut&ocirc;nomo com acesso ilimitado &agrave;s informa&ccedil;&otilde;es internas do projeto para responder aos questionamentos vindos dos usu&aacute;rios ou de entidades n&atilde;o vinculadas ao projeto. O Comit&ecirc; de Transpar&ecirc;ncia trabalha para que o <strong>MUDAMOS</strong> seja um projeto participativo, colaborativo e que cumpre suas pol&iacute;ticas de privacidade e seguran&ccedil;a. Ele &eacute; formado por um representante de uma organiza&ccedil;&atilde;o da sociedade civil; um representante do poder p&uacute;blico; uma pessoa que exer&ccedil;a atividade acad&ecirc;mica, cient&iacute;fica cultural ou art&iacute;stica; uma pessoa notoriamente reconhecida que exer&ccedil;a atividades pertinentes ao projeto e um diretor do ITS Rio.</p>
<p dir="ltr">O Comit&ecirc; de Transpar&ecirc;ncia atua em parceria com o Ombudsperson, um profissional&nbsp;n&atilde;o vinculado e encarregado de olhar criticamente para o projeto, receber cr&iacute;ticas e&nbsp;sugest&otilde;es dos usu&aacute;rios e transmiti-las ao p&uacute;blico. Visite a coluna da Ombudsperson&nbsp;no <a href="temas/seguranca-publica/blog">blog do ciclo sobre Seguran&ccedil;a P&uacute;blica</a>.</p>
<p dir="ltr"><strong>Conhe&ccedil;a nosso Comit&ecirc; de Transpar&ecirc;ncia</strong></p>
<p dir="ltr">Manuel Thedim - Diretor do IETS e nosso antigo Ombudsman (<a href="http://www.iets.org.br/associado/manuel-thedim" target="_blank">http://www.iets.org.br/<wbr />associado/manuel-thedim</a>)</p>
<p dir="ltr">Marlon Reis - Juiz (<a href="http://www.marlonreis.net/" target="_blank">http://www.marlonreis.net/</a>)</p>
<p dir="ltr">Ilana Strozenberg - 0Professora adjunta de Comunica&ccedil;&atilde;o na ECO-UFRJ e membro do O Instituto (<a href="http://oinstituto.org.br/" target="_blank">http://oinstituto.org.br</a>)</p>
<p dir="ltr">Bernardo Sorj - Professor titular de Sociologia da UFRJ, diretor do Centro Edelstein de Pesquisas Sociais (<a href="http://www.bernardosorj.com.br/" target="_blank">http://www.bernardosorj.com.<wbr />br/</a>)</p>
<p dir="ltr">S&eacute;rgio Branco - Diretor executivo do ITS Rio (<a href="http://itsrio.org/sobre-o-its/equipe/" target="_blank">http://itsrio.org/sobre-o-<wbr />its/equipe/</a>)</p>',
  # picture: 'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/conselho3.jpg',
  picture: 'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/comite2.jpg',
  release_date: Time.zone.now,
  slug: 'comite-de-transparencia'
  # plugin_relation: plugin_relation_blog_sp
)

fases_blog_file = File.new "#{Rails.root}/app/assets/images/fases_blog.jpg", "r"

# FOTO DO BAR
BlogPost.where(title: 'Como Funciona o Ciclo sobre Segurança Pública?').first_or_create(
  content: '<p><strong>Participa&ccedil;&atilde;o</strong></p>
<p><span style="font-weight: 400;">Voc&ecirc; participa respondendo e dando sua opini&atilde;o sobre as seis quest&otilde;es relacionadas &agrave; seguran&ccedil;a p&uacute;blica no Brasil. Interaja com as respostas de outros usu&aacute;rios, concordando ou discordando respeitosamente. Esta &eacute; a maneira mais construtiva de fazer o debate avan&ccedil;ar, e cada opini&atilde;o &eacute; muito importante para este projeto colaborativo.</span></p>
<p><strong>Relatoria</strong></p>
<p><span style="font-weight: 400;">A discuss&atilde;o ser&aacute; compilada em um documento que apresentar&aacute; as solu&ccedil;&otilde;es propostas durante a fase de participa&ccedil;&atilde;o. Este documento trar&aacute; a s&iacute;ntese da discuss&atilde;o e a an&aacute;lise de uma equipe de&nbsp;especialistas no tema debatido. Os documentos gerados por </span><strong>MUDAMOS</strong><span style="font-weight: 400;"> t&ecirc;m papel orientador para pol&iacute;ticas p&uacute;blicas (</span><em><span style="font-weight: 400;">policy briefing</span></em><span style="font-weight: 400;">) e ser&atilde;o disponibilizados ao p&uacute;blico e aos atores relevantes ligados &agrave; elabora&ccedil;&atilde;o e execu&ccedil;&atilde;o destas pol&iacute;ticas.</span></p>
<p><span style="font-weight: 400;">No ciclo sobre seguran&ccedil;a p&uacute;blica, </span><strong>MUDAMOS</strong><span style="font-weight: 400;"> ter&aacute; a consultoria especializada do antrop&oacute;logo <a href="http://www.luizeduardosoares.com/" target="_blank">Luiz Eduardo Soares</a><span style="font-weight: 400;">.</span></p>
<p><span style="font-weight: 400;">Para sugest&otilde;es e cr&iacute;ticas, contate a nossa </span><strong>Ombudsperson</strong><span style="font-weight: 400;"> (email: </span><a href="mailto:ombudsman@mudamos.org"><span style="font-weight: 400;">ombudsperson@mudamos.org</span></a><span style="font-weight: 400;">)</span></p>
<p><span style="font-weight: 400;">Saiba quem &eacute; e o que faz nossa <a href="/temas/seguranca-publica/blog/sobre-a-ombudsperson-silvia-ramos">Ombudsperson</a>.</span></p>',
  picture: 'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/fases_blog.jpg',
  release_date: Time.zone.now,
  slug: 'como-funciona-o-ciclo-sobre-seguranca-publica',
  plugin_relation: plugin_relation_blog_sp
)

ombudsperson_file = File.new "#{Rails.root}/app/assets/images/silvia_ramos.jpg", "r"

BlogPost.where(title: 'Sobre a Ombudsperson Silvia Ramos').first_or_create(
  content: '<p><span style="font-weight: 400;">Ombudsperson &eacute; um profissional n&atilde;o vinculado e encarregado de olhar criticamente para o projeto, receber cr&iacute;ticas e sugest&otilde;es dos usu&aacute;rios e transmiti-las ao p&uacute;blico no <a href="temas/seguranca-publica/blog">blog do ciclo de seguran&ccedil;a p&uacute;blica</a>.</span></p>
<p><span style="font-weight: 400;">Silvia Ramos &eacute; coordenadora do <a href="http://www.ucamcesec.com.br">CESeC-UCAM</a> </span><span style="font-weight: 400;">e doutora na &aacute;rea de Viol&ecirc;ncia e Sa&uacute;de pela Funda&ccedil;&atilde;o Oswaldo Cruz. Tem experi&ecirc;ncia em pesquisas sobre viol&ecirc;ncia urbana e seguran&ccedil;a p&uacute;blica, com foco na rela&ccedil;&atilde;o entre juventude, pol&iacute;cia, m&iacute;dia e movimentos sociais. </span><span style="font-weight: 400;">Coordenou o programa das UPPs Sociais no Rio de Janeiro em 2010.</span><span style="font-weight: 400;">Foi convidada para ser nossa ombudsperson por ter vasta experi&ecirc;ncia na &aacute;rea, tanto em pesquisas acad&ecirc;micas quanto </span><span style="font-weight: 400;">junto aos movimentos sociais </span><span style="font-weight: 400;">e pela habilidade de dialogar com diferentes setores da sociedade. &Eacute; co-autora dos livros </span><em><span style="font-weight: 400;">M&iacute;dia e viol&ecirc;ncia: tend&ecirc;ncias na cobertura de criminalidade e seguran&ccedil;a p&uacute;blica no Brasil</span></em><span style="font-weight: 400;">, com Anabela Paiva (2007) e </span><em><span style="font-weight: 400;">Elemento suspeito: abordagem policial e discrimina&ccedil;&atilde;o na cidade do Rio de Janeiro</span></em><span style="font-weight: 400;">, com Leonarda Musumeci (2005)</span><span style="font-weight: 400;"> e de textos sobre juventude, como </span><em><span style="font-weight: 400;">Meninos do Rio: jovens, viol&ecirc;ncia armada e pol&iacute;cia nas favelas cariocas</span></em><span style="font-weight: 400;"> (Unicef, 2009).</span></p>
<p><span style="font-weight: 400;">Para falar com a nossa ombudsperson, escreva para <a href="mailto:ombudsperson@mudamos.org">ombudsperson@mudamos.org</a>.</span></p>',
  picture: 'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/silvia_ramos.jpg',
  release_date: Time.zone.now,
  slug: 'sobre-a-ombudsperson-silvia-ramos',
  plugin_relation: plugin_relation_blog_sp
)

BlogPost.where(title: 'Por que discutir Segurança Pública?').first_or_create(
  content: '<p>A seguran&ccedil;a p&uacute;blica &eacute; um dos grandes desafios do Brasil hoje. Avan&ccedil;os alcan&ccedil;ados&nbsp;nas &uacute;ltimas d&eacute;cadas na redu&ccedil;&atilde;o da desigualdade e na amplia&ccedil;&atilde;o das pol&iacute;ticas sociais&nbsp;contrastam com crescentes indicadores de viol&ecirc;ncia e imobilismo no que diz respeito&nbsp;&agrave;s pol&iacute;ticas de seguran&ccedil;a p&uacute;blica. A maior incid&ecirc;ncia de crimes violentos, tanto nos&nbsp;grandes centros urbanos como no interior do pa&iacute;s, fazem da seguran&ccedil;a uma&nbsp;preocupa&ccedil;&atilde;o crescente da popula&ccedil;&atilde;o e dos dirigentes. Ainda que a inadequa&ccedil;&atilde;o do&nbsp;atual modelo seja clara, a aus&ecirc;ncia de um debate mais profundo tem se mostrado um&nbsp;grande empecilho &agrave; formula&ccedil;&atilde;o de propostas alternativas.</p>
<p>A transforma&ccedil;&atilde;o da situa&ccedil;&atilde;o da seguran&ccedil;a p&uacute;blica no pa&iacute;s passa necessariamente&nbsp;pelo debate a respeito de nossas pol&iacute;cias. De maneira geral, podemos afirmar que os&nbsp;servi&ccedil;os hoje prestados pelas institui&ccedil;&otilde;es s&atilde;o de qualidade insatisfat&oacute;ria. Frequentes&nbsp;den&uacute;ncias sobre atua&ccedil;&atilde;o com emprego de viol&ecirc;ncia desproporcional e corrup&ccedil;&atilde;o&nbsp;afetam a confian&ccedil;a da popula&ccedil;&atilde;o nas for&ccedil;as policiais e acabam por refor&ccedil;ar esse&nbsp;quadro violento. Ao mesmo tempo, a capacidade investigativa tem se mostrado muitodeficiente, com baix&iacute;ssimas taxas de elucida&ccedil;&atilde;o para todos os crimes, mesmo os mais&nbsp;graves, contra a vida.</p>
<p>Os policiais, em sua maioria, tamb&eacute;m s&atilde;o v&iacute;timas do atual modelo, sendo obrigados a&nbsp;trabalhar em condi&ccedil;&otilde;es prec&aacute;rias, sem equipamentos adequados, expondo sua vida a&nbsp;risco. Sem valoriza&ccedil;&atilde;o, s&atilde;o colocados em situa&ccedil;&atilde;o de forte estresse emocional, sem&nbsp;amparo adequado, sofrendo inclusive com o estigma que h&aacute; em torno da profiss&atilde;o.<br />N&atilde;o &eacute; por acaso que a maioria dos policiais &eacute; a favor de mudan&ccedil;as profundas no atual&nbsp;modelo.</p>
<p>O nosso objetivo &eacute; fazer ressoar esse debate, envolvendo o m&aacute;ximo de&nbsp;atores poss&iacute;veis, das for&ccedil;as policiais a entidades da sociedade civil. A&nbsp;organiza&ccedil;&atilde;o das pol&iacute;cias, que n&atilde;o sofreu altera&ccedil;&otilde;es significativas na&nbsp;Constitui&ccedil;&atilde;o de 1988, &eacute; determinada em seu artigo 144. Existe uma s&eacute;rie de&nbsp;Propostas de Emendas &agrave; Constitui&ccedil;&atilde;o (PEC) tratando de mudan&ccedil;as nesse&nbsp;artigo. Para que possamos estruturar o debate em cima de propostas&nbsp;concretas, escolhemos debater a PEC 51, de 2013. Essa PEC foi escolhida por&nbsp;ser a mais abrangente entre as propostas de reforma policial, tocando em uma&nbsp;s&eacute;rie de temas sens&iacute;veis e decisivos dentro do debate.</p>
<p>O texto abaixo, de autoria do antrop&oacute;logo Luiz Eduardo Soares, apresenta de&nbsp;forma detalhada um diagn&oacute;stico da seguran&ccedil;a p&uacute;blica no pa&iacute;s e a necessidade&nbsp;das reformas previstas pela PEC 51.<strong> MUDAMOS</strong> prop&otilde;e uma discuss&atilde;o qualificada&nbsp;sobre os temas trazidos pela PEC 51. H&aacute; espa&ccedil;o para concord&acirc;ncias, discord&acirc;ncias e&nbsp;cria&ccedil;&atilde;o de novas propostas. Vamos debater?</p>
<p><strong>Sobre MUDAMOS e a PEC-51</strong></p>
<p>Luiz Eduardo Soares</p>
<p style="text-align: left;">&nbsp; &nbsp; &nbsp; &nbsp;A situa&ccedil;&atilde;o da seguran&ccedil;a p&uacute;blica no Brasil &eacute; t&atilde;o dram&aacute;tica, que ningu&eacute;m est&aacute; satisfeito:&nbsp;nem a sociedade, nem os policiais. 56 mil pessoas s&atilde;o assassinadas por ano, no pa&iacute;s. S&atilde;o 29&nbsp;v&iacute;timas por 100 mil habitantes. A maioria das v&iacute;timas s&atilde;o jovens pobres e negros, moradores&nbsp;de territ&oacute;rios socialmente vulner&aacute;veis. Entretanto, as investiga&ccedil;&otilde;es n&atilde;o esclarecem mais do&nbsp;que 8% desses crimes, que s&atilde;o os mais graves, porque violam o bem mais valioso: a vida. Esse&nbsp;patamar de homic&iacute;dios dolosos vem se repetindo ao longo dos anos, o que mostra que n&atilde;o&nbsp;temos conseguido preveni-los. Apesar de 92% de impunidade, no que se refere aos homic&iacute;dios&nbsp;dolosos, nosso pa&iacute;s tem a quarta popula&ccedil;&atilde;o penitenci&aacute;ria do mundo (607 mil presos, em 2014,&nbsp;ou 300 por 100 mil habitantes) e a segunda taxa de crescimento mais elevada. Esses dados&nbsp;mostram que alguma coisa est&aacute; profundamente errada. Prendemos muito, mas&nbsp;negligenciamos a viol&ecirc;ncia &agrave; qual dever&iacute;amos dedicar aten&ccedil;&atilde;o priorit&aacute;ria. As pris&otilde;es s&atilde;o&nbsp;verdadeiras masmorras medievais &ndash;nas palavras do pr&oacute;prio ministro da Justi&ccedil;a--, que&nbsp;desrespeitam a Lei de Execu&ccedil;&otilde;es Penais, impondo aos presos um pesado excedente de pena.&nbsp;N&atilde;o surpreende que o n&iacute;vel de reincid&ecirc;ncia se aproxime de 80%. E o que &eacute; pior, milhares est&atilde;o&nbsp;l&aacute; sem ter agido com viol&ecirc;ncia, estar armados ou manter v&iacute;nculos com organiza&ccedil;&otilde;es&nbsp;criminosas: apenas vendiam subst&acirc;ncias il&iacute;citas. Se n&atilde;o tinham v&iacute;nculos, o sistema&nbsp;penitenci&aacute;rio providenciar&aacute; para que se te&ccedil;am. Em resumo: estamos contratando viol&ecirc;ncia&nbsp;futura, quando imaginamos a estar prevenindo.&nbsp;</p>
<p style="text-align: left;">&nbsp; &nbsp; &nbsp; &nbsp;Policiais matam e morrem demais. Execu&ccedil;&otilde;es extra-judiciais multiplicam-se, na medida&nbsp;em que se difunde a cren&ccedil;a de que estamos em uma guerra e que a miss&atilde;o do policial &eacute;&nbsp;combater o inimigo. Segmentos numerosos envolvem-se em corrup&ccedil;&atilde;o, degradando a imagem&nbsp;das institui&ccedil;&otilde;es e liquidando a confian&ccedil;a da sociedade que lhes seria imprescind&iacute;vel. Por outro&nbsp;lado, centenas de milhares de policiais trabalham em condi&ccedil;&otilde;es degradantes, recebendo&nbsp;sal&aacute;rios indignos, submetidos a jornadas de trabalho desumanas, pressionados ao extremo,&nbsp;experimentando s&eacute;rios dist&uacute;rbios ps&iacute;quicos. Est&atilde;o carentes de apoio, forma&ccedil;&atilde;o e treinamento&nbsp;adequados, e equipamento compat&iacute;vel com os riscos envolvidos em suas atividades. Quase&nbsp;todas as PMs mant&ecirc;m regimes disciplinares que autorizam pris&otilde;es administrativas de policiais&nbsp;segundo o arb&iacute;trio dos superiores hier&aacute;rquicos, sem o devido processo legal. O grau de&nbsp;explora&ccedil;&atilde;o do trabalhador policial atinge este ponto porque o estatuto militar proibe a&nbsp;sindicaliza&ccedil;&atilde;o de seus profissionais. Por outro lado, a maioria est&aacute; insatisfeita com as&nbsp;estruturas organizacionais de suas institui&ccedil;&otilde;es, as quais, por n&atilde;o se ordenarem em carreira&nbsp;&uacute;nica, geram duas pol&iacute;cias em cada uma: a PM dos pra&ccedil;as e a PM dos oficiais; a pol&iacute;cia civil dos&nbsp;agentes (investigadores, detetives, escriv&atilde;es, inspetores, peritos) e a pol&iacute;cia civil dos&nbsp;delegados. Al&eacute;m disso, a grande maioria dos profissionais de seguran&ccedil;a p&uacute;blica gostaria que&nbsp;fosse abolida a divis&atilde;o do ciclo do trabalho policial, que hoje separa a pol&iacute;cia que investiga (a&nbsp;pol&iacute;cia civil) da pol&iacute;cia cuja tarefa &eacute; ostensiva e preventiva (a pol&iacute;cia militar). A pol&iacute;cia federal&nbsp;constitui um caso &agrave; parte e a pol&iacute;cia rodovi&aacute;ria federal tamb&eacute;m apresenta algumas&nbsp;peculiaridades. Simplificadamente, pode-se dizer que a PF cumpre ciclo completo e a PRF&nbsp;restringe-se &agrave;s fun&ccedil;&otilde;es ostensivo-preventivas.</p>
<p style="text-align: left;">&nbsp; &nbsp; &nbsp; &nbsp;Acumulam-se, na sociedade e nas pol&iacute;cias, cr&iacute;ticas ao modelo policial e, mais&nbsp;amplamente, &agrave; arquitetura institucional da seguran&ccedil;a p&uacute;blica, isto &eacute;, ao modo pelo qual a&nbsp;Constitui&ccedil;&atilde;o determina que sejam organizados o conjunto das institui&ccedil;&otilde;es que atuam na &aacute;rea&nbsp;e suas inter-rela&ccedil;&otilde;es, assim como a distribui&ccedil;&atilde;o de responsabilidades. A Uni&atilde;o participa pouco,&nbsp;salvo nas crises. Os munic&iacute;pios s&atilde;o praticamente esquecidos, no artigo 144 da Constitui&ccedil;&atilde;o. O&nbsp;peso maior cai sobre os ombros dos estados, os quais s&atilde;o muito diferentes, uma vez que o&nbsp;Brasil &eacute; um pa&iacute;s continental. As necessidades do estado do Amazonas, no campo da seguran&ccedil;a&nbsp;p&uacute;blica, poderiam ser atendidas por um modelo policial que servisse bem ao estado de S&atilde;o&nbsp;Paulo?</p>
<p style="text-align: left;">&nbsp; &nbsp; &nbsp; &nbsp;Como se v&ecirc;, s&atilde;o muitas as quest&otilde;es. Al&eacute;m de numerosas, s&atilde;o interligadas. Ao&nbsp;contr&aacute;rio das pol&iacute;cias, que n&atilde;o s&atilde;o interligadas, n&atilde;o formam um sistema, e este &eacute; um dos&nbsp;problemas chave. A experi&ecirc;ncia internacional, as eventuais boas pr&aacute;ticas nacionais e o bom&nbsp;senso indicam que elas deveriam compor um sistema, o qual estimulasse a coopera&ccedil;&atilde;o e n&atilde;o a&nbsp;rivalidade, o refor&ccedil;o m&uacute;tuo em vez da competi&ccedil;&atilde;o, a integra&ccedil;&atilde;o e n&atilde;o a fragmenta&ccedil;&atilde;o, que&nbsp;dispersa energia, conhecimento e recursos. Por isso, solu&ccedil;&otilde;es t&oacute;picas e melhorias aqui e ali&nbsp;n&atilde;o estariam &agrave; altura da complexidade do desafio. Seriam gambiarras, puxadinhos&nbsp;institucionais, que apenas postergariam mudan&ccedil;as substanciais. Estas, infelizmente, t&ecirc;m sido&nbsp;adiadas desde a promulga&ccedil;&atilde;o da Constiui&ccedil;&atilde;o, em 1988. Naquela oportunidade, o Brasil foi&nbsp;passado a limpo. As mais diversas &aacute;reas foram redesenhadas, a partir de novos par&acirc;metros,&nbsp;para se adaptarem ao Estado democr&aacute;tico de direito, ent&atilde;o instaurado. A seguran&ccedil;a p&uacute;blica,&nbsp;entretanto, permaneceu &agrave; sombra, como o patinho feio da hist&oacute;ria. Por motivos pol&iacute;ticos, foi&nbsp;deixada de lado. A correla&ccedil;&atilde;o de for&ccedil;as ainda n&atilde;o permitia avan&ccedil;os. Temia-se o poder do&nbsp;regime autorit&aacute;rio, que, mesmo superado, mantinha seus tent&aacute;culos no meio pol&iacute;tico, em&nbsp;v&aacute;rias institui&ccedil;&otilde;es e na sociedade. Sendo a seguran&ccedil;a uma &aacute;rea especialmente sens&iacute;vel para os&nbsp;militares, os constituintes optaram por n&atilde;o promover modifica&ccedil;&otilde;es e o pa&iacute;s herdou a&nbsp;arquitetura institucional que a ditadura organizara para atender aos seus objetivos. A&nbsp;Constitui&ccedil;&atilde;o assimilou e consagrou este legado, no artigo 144. Hoje, os problemas pol&iacute;ticos&nbsp;que havia no per&iacute;odo da transi&ccedil;&atilde;o n&atilde;o existem mais, no entanto o pa&iacute;s ainda est&aacute; &agrave; espera de&nbsp;uma iniciativa de transforma&ccedil;&atilde;o que, finalmente, estenda ao campo da seguran&ccedil;a a transi&ccedil;&atilde;o&nbsp;democr&aacute;tica, alterando o artigo 144.</p>
<p style="text-align: left;">&nbsp; &nbsp; &nbsp; &nbsp;Para definir novos rumos e formar uma coaliz&atilde;o ampla o suficiente para conferir for&ccedil;a&nbsp;pol&iacute;tica ao esfor&ccedil;o de mudan&ccedil;a, &eacute; preciso ouvir os policiais de todas as esferas, os estudiosos e&nbsp;a sociedade civil, buscando construir um consenso m&iacute;nimo em torno das reformas b&aacute;sicas. A&nbsp;PEC-51, apresentada pelo senador Lindbergh Farias em outubro de 2013, seguiu e continua a&nbsp;seguir este caminho: resultou de mais de uma d&eacute;cada de consultas, di&aacute;logos e negocia&ccedil;&otilde;es.&nbsp;Nem por isso, expressa unanimidade. N&atilde;o h&aacute; unanimidade em mat&eacute;rias complexas,&nbsp;naturalmente controversas e pol&ecirc;micas. Entretanto, parte de alguns diagn&oacute;sticos e prop&otilde;e&nbsp;alguns caminhos de solu&ccedil;&atilde;o que talvez sejam capazes de obter ades&atilde;o ampla o suficiente para&nbsp;impulsionar as transforma&ccedil;&otilde;es cada vez mais urgentes. Esta plataforma de debate tem o&nbsp;prop&oacute;sito de testar esta hip&oacute;tese e de colher subs&iacute;dios para aperfei&ccedil;oar as propostas&nbsp;contempladas na PEC-51. Por outro lado, o bom debate requer abertura dos participantes para&nbsp;rever seus pr&oacute;prios pontos de vista e ser convencidos por outros argumentos. Assim, os&nbsp;proponentes da PEC-51 concluir&atilde;o este processo dial&oacute;gico satisfeitos se descobrirem que&nbsp;est&atilde;o errados e que h&aacute; um outro conjunto de propostas melhor e mais apto a conquistar o&nbsp;consenso m&iacute;nimo, indispens&aacute;vel para sustentar uma ampla coaliz&atilde;o reformista. Nesse caso,&nbsp;dispomo-nos a somar for&ccedil;as e apoiar as melhores ideias. O importante ser&aacute; salvar a seguran&ccedil;a&nbsp;p&uacute;blica da in&eacute;rcia pol&iacute;tica. Acreditamos que este seja o caminho para a constru&ccedil;&atilde;o do futuro&nbsp;com mais democracia, participa&ccedil;&atilde;o, transpar&ecirc;ncia e compromisso com a equidade e a justi&ccedil;a.</p>
<p style="text-align: left;">&nbsp; &nbsp; &nbsp; &nbsp;Resta enfatizar o seguinte ponto: a seguran&ccedil;a p&uacute;blica envolve m&uacute;ltiplas dimens&otilde;es&ndash;desde a economia &agrave; cultura, passando pelas mais diversas quest&otilde;es sociais, como o racismo,&nbsp;as desigualdades, as defici&ecirc;ncias no acesso &agrave; cidadania plena, que inclui a escolaridade, as&nbsp;iniquidades-- e requer, portanto, pol&iacute;ticas p&uacute;blicas intersetoriais e convergentes. A pr&oacute;pria&nbsp;viol&ecirc;ncia policial, por exemplo, n&atilde;o se manteria sem a t&aacute;cita autoriza&ccedil;&atilde;o concedida por boa&nbsp;parte da sociedade. Em outras palavras, seguran&ccedil;a n&atilde;o &eacute; problema exclusivamente policial ou&nbsp;da Justi&ccedil;a criminal. Isso n&atilde;o significa que as pol&iacute;cias e a estrutura institucional da seguran&ccedil;a&nbsp;p&uacute;blica n&atilde;o cumpram papel muito importante. O repert&oacute;rio do debate &eacute; mais amplo do que o&nbsp;espectro tem&aacute;tico coberto pela discuss&atilde;o que pretendemos travar nesta plataforma virtual.&nbsp;Por&eacute;m, esta tem sido uma armadilha perigosa, porque, em nome da complexidade e da&nbsp;diversidade dos fatores relevantes, nunca o foco das aten&ccedil;&otilde;es se dirige &agrave; problem&aacute;tica policial,&nbsp;o que tem provocado sua exclus&atilde;o da agenda priorit&aacute;ria nacional e a consequente&nbsp;conserva&ccedil;&atilde;o do status quo. Por outro lado, quando discutem seguran&ccedil;a, a sociedade, os&nbsp;pol&iacute;ticos e a m&iacute;dia tendem a faz&ecirc;-lo em momentos de crise, limitando suas propostas ao&nbsp;endurecimento das penas.</p>
<p style="text-align: left;">&nbsp; &nbsp; &nbsp; &nbsp;Chegou a hora das quest&otilde;es policiais. &Eacute; urgente inscrev&ecirc;-las no centro da agenda&nbsp;p&uacute;blica. Lan&ccedil;amos aqui a plataforma virtual destinada a debater uma proposta de mudan&ccedil;a, a&nbsp;PEC-51. Ser&aacute; uma forma objetiva de difundir a discuss&atilde;o, estimular a participa&ccedil;&atilde;o e, gra&ccedil;as &agrave;&nbsp;focaliza&ccedil;&atilde;o de temas espec&iacute;ficos, qualificar o debate. Se n&atilde;o alcan&ccedil;armos um consenso&nbsp;m&iacute;nimo, pelo menos contribuiremos para que as posi&ccedil;&otilde;es se enrique&ccedil;am e os pontos de&nbsp;diverg&ecirc;ncia se identifiquem com precis&atilde;o, facilitando o di&aacute;logo e abrindo caminho para a&nbsp;negocia&ccedil;&atilde;o das mudan&ccedil;as poss&iacute;veis.</p>
<p><strong>Nota de esclarecimento:</strong> Esta proposta n&atilde;o &eacute; de responsabilidade do&nbsp;ITS Rio, seus diretores e funcion&aacute;rios.</p>',
  picture: 'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/IMG_9209.jpg',
  release_date: Time.zone.now,
  slug: 'por-que-discutir-seguranca-publica',
  plugin_relation: plugin_relation_blog_sp
)


stairs_file = File.new "#{Rails.root}/app/assets/images/Escada.jpg", "r"

BlogPost.where(title: 'Como Funciona?').first_or_create(
  content: '<p><strong>Participa&ccedil;&atilde;o</strong></p>
<p><span style="font-weight: 400;">Voc&ecirc; pode participar priorizando assuntos, respondendo &agrave;s perguntas propostas em cada ciclo e interagindo com outros usu&aacute;rios. Nesta fase, </span><strong>MUDAMOS</strong><span style="font-weight: 400;"> conta com a colabora&ccedil;&atilde;o de diversos segmentos da sociedade para discutir e construir propostas de a&ccedil;&atilde;o para os temas em debate. No primeiro momento de cada ciclo, </span><strong>MUDAMOS</strong><span style="font-weight: 400;"> funciona como um espa&ccedil;o aberto para ideias e opini&otilde;es diversas que ser&atilde;o tratadas com igualdade. Interagir com as respostas de outros usu&aacute;rios, concordando ou discordando respeitosamente, &eacute; a maneira mais construtiva de fazer o debate avan&ccedil;ar e cada opini&atilde;o &eacute; muito importante para este projeto colaborativo.</span></p>
<p><strong>Relatoria</strong></p>
<p><span style="font-weight: 400;">A discuss&atilde;o de cada ciclo ser&aacute; compilada em um documento que apresentar&aacute; as solu&ccedil;&otilde;es propostas durante a fase de participa&ccedil;&atilde;o. Este documento trar&aacute; a s&iacute;ntese da discuss&atilde;o e a an&aacute;lise de uma equipe de especialistas no tema debatido. Os documentos gerados por </span><strong>MUDAMOS</strong><span style="font-weight: 400;"> t&ecirc;m papel orientador para pol&iacute;ticas p&uacute;blicas (</span><em><span style="font-weight: 400;">policy briefing</span></em><span style="font-weight: 400;">) e ser&atilde;o disponibilizados ao p&uacute;blico e aos atores relevantes ligados &agrave; elabora&ccedil;&atilde;o e execu&ccedil;&atilde;o destas pol&iacute;ticas.</span></p>',
  picture: 'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/Escada.jpg',
  release_date: Time.zone.now,
  slug: 'como-funciona'
  # plugin_relation: plugin_relation_blog_sp
)


anonymous_file = File.new "#{Rails.root}/app/assets/images/15282150980_773d4bceec_o.jpg", "r"

BlogPost.where(title: 'Postagens Anônimas').first_or_create(
  content: '<p>Por ser um projeto que refletir&aacute; a opini&atilde;o e posicionamento de cidad&atilde;os reais,&nbsp;<strong>MUDAMOS</strong> pede que seu cadastro inclua seu CPF. Isso ajuda a dar credibilidade ao&nbsp;documento final e mais for&ccedil;a &agrave;s suas propostas. Tamb&eacute;m &eacute; importante informar qual&nbsp;seu setor de atua&ccedil;&atilde;o, j&aacute; que esta informa&ccedil;&atilde;o ajuda a identificar quais quest&otilde;es e&nbsp;posicionamentos s&atilde;o mais relevantes para determinados grupos. No entanto,&nbsp;<strong>MUDAMOS</strong> reconhece que por, raz&otilde;es profissionais ou pessoais, alguns usu&aacute;rios&nbsp;possam preferir n&atilde;o ter seus nomes reais revelados. Por isso, disponibilizamos a&nbsp;op&ccedil;&atilde;o de postagens an&ocirc;nimas. Ao escolher esta op&ccedil;&atilde;o, seus dados cadastrais ser&atilde;o&nbsp;preservados e sua postagem aparecer&aacute; sob um pseud&ocirc;nimo aleat&oacute;rio gerado pelo&nbsp;sistema. Conhe&ccedil;a nossa nossa Pol&iacute;tica de Privacidade <a href="../termos-de-uso">aqui</a>.</p>',
  # picture: 'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/15282150980_773d4bceec_o.jpg',
  # picture: 'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/anonimato-comtexto.jpg',
  picture: 'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/anonimato-semtexto.jpg',
  release_date: Time.zone.now,
  slug: 'postagens-anonimas'
  # plugin_relation: plugin_relation_blog_sp
)

cities_sql = File.new "#{Rails.root}/db/states_and_cities.sql", "r"
ActiveRecord::Base.connection.execute(cities_sql.read)



require 'csv'
alias_csv = CSV.parse(File.read("#{Rails.root}/app/assets/alias_names/nomes.csv"))[1..-1].flatten.uniq


inserts = alias_csv[0..20000].map { |x| "('#{x}', now(), now())" }.join(", ")
alias_sql = "INSERT INTO alias_names (name, created_at, updated_at) VALUES #{inserts}"

ActiveRecord::Base.connection.execute(alias_sql)
# alias_csv[0..20000].each do |n|
#   AliasName.create(name: n)
# end


#Inserting the library materials
materials_csv = CSV.parse(File.read("#{Rails.root}/app/assets/library/library.csv"))[1..-1]

materials_csv.each do |row|
  next if row.nil?
  m = Cycle.find('seguranca-publica').materials.new(
    position: row[0].to_i,
    title: row[1],
    source: row[2],
    category: row[3],
    external_link: row[4],
    themes: row[5],
    keywords: row[6],
    description: row[7]
  )
  m.save
end
