class Expense < ActiveRecord::Base
  has_one :invoice
  has_one :purchase_order, through: :invoice
  has_one :invoice_receipt, through: :invoice
  has_one :provider, through: :invoice
  has_one :construction, through: :invoice
  has_many :item_materials, through: :invoice
end
