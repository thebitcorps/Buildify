class Requisition < ActiveRecord::Base
  belongs_to :construction
  has_many :item_materials

  def purchase_orders
    PurchaseOrder.find item_materials.pluck(:purchase_order_id)
  end

  def invoices
    Invoice.find purchase_orders.map(&:invoice_id)
  end
end
