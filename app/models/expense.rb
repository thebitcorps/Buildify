class Expense < ActiveRecord::Base
  has_one :invoice
  has_many :purchase_orders, through: :invoice
  has_one :invoice_receipt, through: :invoice

  def item_materials
    invoice.item_materials
  end
end