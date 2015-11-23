Rails.application.routes.draw do
  resources :measure_units
  devise_for :users
  resources :users do
    collection do
      get 'edit_password'
      patch 'update_password'
    end
  end

  resources :item_materials
  resources :providers
  resources :purchase_orders
  resources :materials
  resources :requisitions
  resources :constructions
  resources :payments
  resources :estimates
  resources :invoices do
    get 'document', on: :member, defaults: { format: 'pdf' }
  end
  resources :billing_adjustments
  root to: "home#index"
end
