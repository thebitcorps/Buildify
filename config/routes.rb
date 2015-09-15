Rails.application.routes.draw do
  devise_for :users
  resources :users do
    collection do
      get 'edit_password'
      patch 'update_password'
    end
  end
  resources :purchase_orders
  resources :materials
  resources :requisitions
  resources :constructions
  resources :estimates
  root to: "home#index"
end
