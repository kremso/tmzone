Tmzone::Application.routes.draw do
  require 'girl_friday/server'
  mount GirlFriday::Server => '/girl_friday'

  root to: 'marks#research'

  get 'marks/research', to: 'marks#research'
  get 'marks/protect', to: 'marks#protect'

  get 'marks/search', to: 'marks#search'
  get 'marks/watch', to: 'marks#watch'

  post 'marks/watch', to: 'marks#watch!'
  post 'marks/search', to: 'marks#search!'
  get 'marks/results', to: 'marks#results'

  get 'info/:slug', to: 'static_pages#show', as: 'static_page'

  get 'contact', to: 'contact#show'
  post 'contact', to: 'contact#send_email'

  namespace :admin do
    resources :static_pages
  end
end
