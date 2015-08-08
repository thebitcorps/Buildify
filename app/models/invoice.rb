class Invoice < ActiveRecord::Base
  has_many :purchase_orders
  belongs_to :expense
  belongs_to :invoice_receipt
  has_one :provider, through: :invoice_receipt

  accepts_nested_attributes_for :purchase_orders
end
