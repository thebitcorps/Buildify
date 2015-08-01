class Invoice < ActiveRecord::Base
  has_many :purchase_orders

  def requisitions
    purchase_orders.collect{|purchase_order| purchase_order.requisition}
  end

  def item_materials
    purchase_orders.collect{|purchase_order| purchase_order.item_materials}.flatten
  end

  def constructions
    requisitions.collect{|requisition| requisition.construction}
  end
end
