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
    post 'generate_invoice_expense'
  end
end
