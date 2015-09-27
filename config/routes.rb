Rails.application.routes.draw do
  resources :measure_units
  devise_for :users
  resources :users do
    collection do
      get 'edit_password'
      patch 'update_password'
    end
  end
  resources :providers
  resources :purchase_orders
  resources :materials
  resources :requisitions
  resources :constructions
  resources :estimates
  resources :invoices
  resources :billing_adjustments
  root to: "home#index"
end
