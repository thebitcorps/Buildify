class PurchaseOrdersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_purchase_order, only: [:show, :document]
  before_action :set_requisition, only: [:new]
  # before_action :filter_sub_out

  # TODO includes item_materials
  def index
    @type_list = sanitized_locked_param
    if params[:construction_id]
      @construction = Construction.find(params[:construction_id])
      @purchase_orders = (instance_eval %Q{@construction.purchase_orders.#{@type_list}.by_folio(#{sanitize_formated_folio}).page(#{params[:page]})})
    else
      @purchase_orders = (class_eval %Q{PurchaseOrder.active.#{@type_list}.by_folio(#{sanitize_formated_folio}).page(#{params[:page]})})
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @construction = @purchase_order.construction
    @item_materials = @purchase_order.item_materials
    @requisition = @purchase_order.requisition

    flash.now[:notice] = "Orden de compra verificada" if @purchase_order.verify_stamp(params[:stamp_string] || '')
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
    # @purchase_order.build_invoice
    # @purchase_order.stamp_it(params[:stamp_purchase_order], current_user)
    respond_to do |format|
      if @purchase_order.save
        format.json {render json: @purchase_order}
      else
        format.json { render json: JSON.parse(@purchase_order.errors.full_messages.to_json), status: :unprocessable_entity}
      end
    end
  end

  def stamp
    @purchase_order = PurchaseOrder.find(params[:id])
    if @purchase_order.stampp!(current_user)
      redirect_to @purchase_order
    else
      redirect_to @purchase_order,alert: 'Autorizar primero orden de compra.'
    end
  end

private
  def sanitize_formated_folio
    if params[:formated_folio].nil?
      "nil"
    else
      "\'#{params[:formated_folio]}\'"
    end
  end

  def set_requisition
    @requisition = Requisition.find params[:requisition_id]
  end

  def set_purchase_order
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  def purchase_order_params
    params.require(:purchase_order).permit(:stamp_purchase_order, :delivery_place, :delivery_address, :delivery_receiver, :requisition_id, :provider_id , :item_material_ids => [])
  end

  def sanitized_locked_param
    ['complete', 'pending','stamped'].include?(params[:type_list]) ? params[:type_list] : 'all'
  end
end
