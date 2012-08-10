Tmzone::Application.routes.draw do
  require 'girl_friday/server'
  mount GirlFriday::Server => '/girl_friday'

  get 'marks/search', to: 'marks#search'
  post 'marks/search', to: 'marks#search!'
  get 'marks/results', to: 'marks#results'
end
