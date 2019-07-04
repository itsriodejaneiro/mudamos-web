class StaticController < ApplicationController
  layout "static"

  caches_action :index, expires_in: 30.minutes
  caches_action :about, expires_in: 1.hour
  caches_action :mobilize, expires_in: 1.hour

  def about
    @title = "Mudamos | Quem somos"
    @image = asset_url("static/screenshot-mudamos-app.png")
    @description= "Assine projetos de lei de iniciativa popular de um jeito simples, rápido e seguro. Desenvolvido pelo ITS Rio e financiado pelo prêmio Desafio Google de Impacto Social."
  end

  def index
    @title = "Mudamos"
    @image = "https://s3-sa-east-1.amazonaws.com/mudamos-images/images/landing/mockup.png"
    @description= "Assine projetos de lei de iniciativa popular pelo seu celular. Transforme a sua cidade, o seu estado e o país."
  end

  def mobilize
    @title = "Mudamos | Guia de Mobilização"
    @image = asset_url("static/mobilize-landscape.png")
    @description= "Mobilize apoiadores para um projeto de lei de iniciativa popular!"
  end
end
