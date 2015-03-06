Rails.application.routes.draw do
  resources :alerts
  get '*path', to: 'home#index'
end
