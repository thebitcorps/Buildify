Rails.application.routes.draw do
  resources :constructions, only: [:new, :create, :index, :show]
  resources :materials, only: [:new, :create, :index]
  resources :providers, only: [:new, :create, :index]
  resources :requisitions, only: [:create, :index, :show] do
    post 'generate_purchase_order'
  end
  resources :item_materials, only: [:create]
  resources :purchase_orders, only: [:update, :show] do
    patch 'update_item_materials'
  end
  resources :expenses, only: [:update, :index]
  resources :invoice_receipts, only: [:create, :show, :update]
  resources :invoices, only: [:create, :show] do
    post 'add_purchase_order'
    post 'remove_purchase_order'
  end
end
