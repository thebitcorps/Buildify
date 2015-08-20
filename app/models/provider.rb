class Provider < ActiveRecord::Base
  has_many :invoices
  has_many :purchase_orders, through: :invoices
  has_many :requisitions, through: :purchase_orders
  has_many :constructions, through: :requisitions
  has_many :payments, through: :invoices
end
