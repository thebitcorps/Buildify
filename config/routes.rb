Rails.application.routes.draw do
  post 'notifications/seen_all' => 'notifications#seen_all', as: :seen_all_notifications
  post 'notification/:id' => 'notifications#seen', as: :seen_notification
  get 'notifications' => 'notifications#index', as: :notifications


  get 'petty_cash_expenses/:id'=> 'petty_cash_expenses#show', :as => :petty_cash_expense
  post '/petty_cash_expenses' => 'petty_cash_expenses#create'


  resources :petty_cashes,except: [:new]
  resources :offices, only: [:new, :create, :show, :edit, :update]

  resources :extensions
  resources :measure_units
  devise_for :users
  resources :users do
    post 'update_lock', on: :member
    collection do
      get 'edit_password'
      patch 'update_password'
    end
  end

  resources :item_materials
  resources :providers
  resources :purchase_orders do
    get 'document', on: :member, defaults: { format: 'pdf' }
    post 'stamp', on: :member
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
