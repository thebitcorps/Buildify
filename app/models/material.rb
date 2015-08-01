class Material < ActiveRecord::Base
  has_many :item_materials

  def purchase_orders
    PurchaseOrder.find item_materials.map(&:purchase_order_id)
  end

  def requisitions
    Requisition.find item_materials.map(&:requisition_id)
  end

  def constructions
    Construction.find requisitions.map(&:construction_id)
  end
end
