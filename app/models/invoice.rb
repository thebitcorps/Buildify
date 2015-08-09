class Invoice < ActiveRecord::Base
  has_many :purchase_orders
  belongs_to :expense
  belongs_to :invoice_receipt
  has_one :provider, through: :invoice_receipt

  def requisitions
    Requisition.find purchase_orders.map(&:requisition_id)
  end

  def constructions
    Construction.find requisitions.map(&:construction_id)
  end
end
