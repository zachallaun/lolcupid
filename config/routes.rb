Rails.application.routes.draw do
  root 'pages#index'

  get 'about', to: 'pages#about'

  get 'summoner/:region/:name', to: 'pages#summoner'
  get 'champions', to: 'pages#champions'
end
