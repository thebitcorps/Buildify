class PurchaseOrdersController < ApplicationController

  def new
    @purchase_oder = PurchaseOrder.new
    requisition = Requisition.find(params[:requisition_id])
    @requisition = JSON.parse requisition.to_json include: [:item_materials => {include: :material}]
    @construction_address = 'requisition.construction.name.to_json'
  end

end
