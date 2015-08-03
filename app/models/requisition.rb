class Requisition < ActiveRecord::Base
  belongs_to :construction
  has_many :item_materials

  def item_materials_not_assigned
    item_materials.where(purchase_order_id: nil)
  end

  def purchase_orders
    PurchaseOrder.find item_materials.pluck(:purchase_order_id).compact
  end

  def invoices
    Invoice.find purchase_orders.map(&:invoice_id)
  end

  def providers
    purchase_orders.collect{|purchase_order| purchase_order.provider}.uniq
  end
end
