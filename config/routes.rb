Rails.application.routes.draw do
  resources :alerts
  get '*path', to: 'fire_sale#index'
end
