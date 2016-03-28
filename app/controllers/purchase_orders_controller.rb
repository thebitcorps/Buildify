class PurchaseOrdersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_purchase_order, only: [:show, :document]
  before_action :set_requisition, only: [:new]
  before_action :filter_sub_out

  def index
    @type_list = sanitized_locked_param
    @construction = Construction.find(params[:construction_id])
    @purchase_orders = (instance_eval %Q{@construction.purchase_orders.#{@type_list}})
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @construction = @purchase_order.construction
    @item_materials = @purchase_order.item_materials
    @requisition = @purchase_order.requisition
    @invoice = @purchase_order.invoice
  end

  def document
  end

  def new
    @purchase_order = PurchaseOrder.new
    requisition = Requisition.find(params[:requisition_id])
    @requisition = JSON.parse requisition.to_json include: [:item_materials => {include: :material}]
    @construction = requisition.construction
  end

  def create
    @purchase_order = PurchaseOrder.new purchase_order_params
    @purchase_order.build_invoice provider_id: params[:provider_id]
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

  def sanitized_locked_param
    ['sent','not_sent'].include?(params[:type_list]) ? params[:type_list] : 'all.order(created_at: :desc)'
  end
end
