class Requisition < ActiveRecord::Base
  belongs_to :construction
  has_many :purchase_orders
  has_many :item_materials

  def item_materials_not_assigned
    item_materials.where(purchase_order_id: nil)
  end

  def invoices
    Invoice.find purchase_orders.map(&:invoice_id)
  end

  def providers
    purchase_orders.collect{|purchase_order| purchase_order.provider}.uniq
  end
end
