class Requisition < ActiveRecord::Base
  belongs_to :construction
  has_many :purchase_orders
  has_many :item_materials
  has_many :invoices, through: :purchase_orders
end
