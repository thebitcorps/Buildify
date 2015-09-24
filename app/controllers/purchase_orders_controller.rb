class PurchaseOrdersController < ApplicationController

  def new
    @purchase_oder = PurchaseOrder.new
    requisition = Requisition.find(params[:requisition_id])
    @requisition = JSON.parse requisition.to_json include: [:item_materials => {include: :material}]
    @construction_address = 'requisition.construction.name.to_json'
  end

  def create
    @purchase_oder = PurchaseOrder.new purchase_order_params
    respond_to do |format|
      if @purchase_oder.save
        format.json {render json: @purchase_oder}
      else
        format.json { render json: JSON.parse(@purchase_oder.errors.full_messages.to_json), status: :unprocessable_entity}
      end
    end

  end

private

  def purchase_order_params
    params.require(:purchase_order).permit(:delivery_place, :delivery_address,:delivery_receiver,:requisition_id,:item_material_ids => [])
  end

end
