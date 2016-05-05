Rails.application.routes.draw do
  root 'pages#index'

  get 'about', to: 'pages#about'

  get 'summoner/:region/:name', to: 'pages#summoner'
  get 'champion/:name', to: 'pages#champion'
  get 'champions', to: 'pages#champions'
end
