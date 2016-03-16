Rails.application.routes.draw do
  resources :offices, except: [:index]

  resources :extensions
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
  resources :purchase_orders do
    get 'document', on: :member, defaults: { format: 'pdf' }
  end
  resources :materials
  resources :requisitions do
    get 'document', on: :member, defaults: { format: 'pdf' }
  end
  resources :constructions
  resources :payments
  resources :estimates
  resources :invoices do
    get 'document', on: :member, defaults: { format: 'pdf' }
  end
  resources :billing_adjustments
  root to: "home#index"
end
