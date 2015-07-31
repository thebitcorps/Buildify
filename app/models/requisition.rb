class Requisition < ActiveRecord::Base
  belongs_to :construction
  has_many :item_materials

  def purchase_orders
  	PurchaseOrder.find item_materials.pluck(:purchase_order_id)
  end
end
