Rails.application.routes.draw do
  resources :executions , only: [:index, :new, :create, :show]
  root   'home#index'
  get    'home/index'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
