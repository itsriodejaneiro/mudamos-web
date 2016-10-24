module BaseRouting
  module RoutingMethods
    def cycle_routes
      resources :blog_posts, path: 'blog', controller: 'cycles/blog_posts'
      resources :subjects, only: [:index, :show], path: 'assuntos', controller: 'cycles/subjects' do
        resources :comments, only: [:index, :create, :update], controller: 'cycles/subjects/comments', path: 'comentarios' do
          resources :comments, only: [:index], path: 'respostas', controller: 'cycles/subjects/comments'
          resources :likes, only: [:create, :destroy], path: 'like', controller: 'cycles/subjects/comments/likes'
          resources :dislikes, only: [:create, :destroy], path: 'dislike', controller: 'cycles/subjects/comments/dislikes'
        end
      end

      resources :materials, only: [:index], path: 'biblioteca', controller: 'cycles/materials'
      resources :vocabularies, only: [:index], path: 'glossário', controller: 'cycles/vocabularies'

      resources :plugin_relations, only: [:show], path: 'plugins', controller: 'cycles/plugin_relations'
    end
  end
end

include BaseRouting::RoutingMethods

Rails.application.routes.draw do
  devise_for :admin_users, controllers: {
    sessions: 'admin/admin_users/sessions',
    registrations: 'admin/admin_users/registrations',
    passwords: 'admin/admin_users/passwords'
  }

  get 'admin', to: 'admin/cycles#index'
  namespace :admin do
    resources :admin_users, path: 'administradores' do
      collection do
        delete "bulk_destroy", to: "admin_users#bulk_destroy", as: :bulk_destroy
      end
    end
    resources :blog_posts, path: 'blog'
    resources :credits, path: 'creditos'
    resources :static_pages, only: [:show, :new, :create, :edit, :update, :destroy], path: 'institucional'
    resources :credit_categories, only: [:new, :create, :edit, :update, :destroy], path: 'categorias-de-credito'
    resources :cycles, only: [:index, :show, :new, :create, :edit, :update], path: 'temas' do
      resources :blog_posts, path: 'blog', controller: 'cycles/blog_posts'
      resources :users, only: [:index, :show], controller: 'cycles/users', path: 'usuarios'
      resources :plugin_relations, only:[:show], path: 'plugins', controller: 'cycles/plugin_relations' do
        resources :subjects, controller: 'cycles/plugin_relations/subjects', path: 'temas' do
          resources :comments, controller: 'cycles/plugin_relations/subjects/comments', path: 'comentarios', only: [:show] do
            resources :comments, controller: 'cycles/plugin_relations/subjects/comments', path: 'comentarios', only: [:new, :create]
          end
        end
        resources :materials, path: 'materiais', controller: 'cycles/materials'
        resources :vocabularies, path: 'termos', controller: 'cycles/vocabularies'
        resources :settings, only: [:create, :update], controller: 'cycles/plugin_relations/settings'
        resources :compilation_files, only: [:update], controller: 'cycles/plugin_relations/compilation_files'
      end
      resources :charts, only: [:index], controller: 'cycles/charts', path: 'graficos-personalizados'
    end
    match 'users/:id/comments', to: 'users#user_comment_csv', via: :get

    resources :users, only: [:index, :show], path: 'usuarios'
    resources :settings, only: [:index, :update], path: 'configuracoes'
    resources :social_links, only: [:create, :update, :destroy]

    resources :grid_highlights, only: [:index, :update], path: 'destaques'
    post "destaques/:id", to: 'grid_highlights#update'

    get 'tinymce_s3_upload/signed_urls' => 'amazon_s3_tinymce#index', as: :signed_urls
    resources :statistics, only: [:index] , path: 'stats'
    match 'stats/users', to: 'statistics#users_csv', via: :get
    match 'stats/comments', to: 'statistics#comments_csv', via: :get
  end

  namespace :api do
    namespace :v1 do
      namespace :users do
        match '/sign_in', to: 'sessions#create', via: :post
        match '/sign_out', to: 'sessions#destroy', via: :delete
        match '/sign_up', to: 'registrations#new', via: :get
        match '/facebook', to: 'oauths#facebook', via: :post
        match '/twitter', to: 'oauths#twitter', via: :post
        resources :notifications
      end
      resource :user, only: [:show]
      resource :registrations, only: [:create, :update], path: 'users', controller: 'users/registrations'
      resource :passwords, only: [:create], path: 'passwords', controller: 'users/passwords'

      # resources :profiles, only: [:index]
      resources :cycles, only: [:index, :show]
      resources :settings, only: [:index]
      resources :subjects, only: [:index, :show] do
        resources :comments, only: [:index, :create, :update, :destroy] do
          resources :comments, only: [:index, :create], as: :children
          resources :likes, only: [:create], controller: 'cycles/subjects/comments/likes'
          match '/likes', to: 'cycles/subjects/comments/likes#destroy', via: :delete
          resources :dislikes, only: [:create], controller: 'cycles/subjects/comments/dislikes'
          match '/dislikes', to: 'cycles/subjects/comments/dislikes#destroy', via: :delete
        end
      end
    end
  end


  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  match '/busca', to: 'search#show', as: :search, via: :get

  resources :blog_posts, path: 'blog'

  # get 'termos-de-uso' => 'static_pages#use_terms', as: :use_terms
  # get 'politica-de-privacidade' => 'static_pages#privacy_policy', as: :privacy_policy
  resources :static_pages, only: [:show], path: 'institucional'
  resources :credits, only:[:index], path: 'creditos'

  match '/:uf/cities', to: 'cities#index', via: :get
  match '/:profile_id/profiles', to: 'profiles#index', via: :get

  match '/ping', to: 'ping#show', via: :get

  root 'cycles#index'

  resources :cycles, only: [:show], path: 'temas' do
    cycle_routes
  end
  resources :cycles, only: [:show], path: '' do
    cycle_routes
  end
end
