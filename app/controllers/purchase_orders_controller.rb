class PurchaseOrdersController < ApplicationController
  before_action :set_purchase_order, only: [:show]
  before_action :set_requisition, only: [:new]

  def index
    @construction = Construction.find(params[:construction_id])
    @purchase_orders = @construction.purchase_orders
  end

  def show
    @construction = @purchase_order.construction
    @item_materials = @purchase_order.item_materials
    @requisition = @purchase_order.requisition
    @invoice = @purchase_order.invoice
  end

  def new
    @purchase_order = PurchaseOrder.new
    requisition = Requisition.find(params[:requisition_id])
    @requisition = JSON.parse requisition.to_json include: [:item_materials => {include: :material}]
    @construction = requisition.construction
  end

  def create
    @purchase_order = PurchaseOrder.new purchase_order_params
    @purchase_order.build_invoice
    respond_to do |format|
      if @purchase_order.save
        format.json {render json: @purchase_order}
      else
        format.json { render json: JSON.parse(@purchase_order.errors.full_messages.to_json), status: :unprocessable_entity}
      end
    end
  end

private

  def set_requisition
    @requisition = Requisition.find params[:requisition_id]
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_purchase_order
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  def purchase_order_params
    params.require(:purchase_order).permit(:delivery_place, :delivery_address,:delivery_receiver,:requisition_id,:item_material_ids => [])
  end

end
