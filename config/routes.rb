Rails.application.routes.draw do
  root to: 'fire_sale#index'
  resources :alerts
  get '*path', to: 'fire_sale#index'
end
