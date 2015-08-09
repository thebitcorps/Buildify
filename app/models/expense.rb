class Expense < ActiveRecord::Base
  has_one :invoice
  has_many :purchase_orders, through: :invoice
  has_one :invoice_receipt, through: :invoice
  has_one :provider, through: :invoice

  def requisitions
    invoice.requisitions
  end

  def constructions
    invoice.constructions
  end
end
