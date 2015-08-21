Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :constructions
  root to: "home#index"
end
