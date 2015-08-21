Rails.application.routes.draw do
  devise_for :users
  resources :users do
    collection do
      get 'edit_password'
      patch 'update_password'
    end
  end
  resources :constructions
  root to: "home#index"
end
