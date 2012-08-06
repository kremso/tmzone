Tmzone::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'marks/search', to: 'marks#search'
  post 'marks/search', to: 'marks#search!'
  get 'marks/results', to: 'marks#results'
end
