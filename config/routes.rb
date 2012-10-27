Tmzone::Application.routes.draw do
  require 'girl_friday/server'
  mount GirlFriday::Server => '/girl_friday'

  root to: 'marks#index'

  get 'marks/search', to: 'marks#search'
  post 'marks/search', to: 'marks#search!'
  get 'marks/results', to: 'marks#results'

  post 'endpoint/log', to: 'endpoint#log'
end
