class PurchaseOrdersController < ApplicationController



  def new
    @purchase_oder = PurchaseOrder.new
    @requisition = JSON.parse Requisition.find(params[:requisition_id]).to_json include: [:item_materials => {:include => :material}]
  end


end
