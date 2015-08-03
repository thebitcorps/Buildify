class RequisitionsController < ApplicationController

  def index
    @construction = Construction.find(params[:construction_id])
    @requisitions = @construction.requisitions
  end

  def show
    @item_material = ItemMaterial.new
    @requisition = Requisition.find(params[:id])
    @item_materials = @requisition.item_materials
    @construction = @requisition.construction
    @materials = Material.all
    @purchase_orders = @requisition.purchase_orders
  end

  def create
    @requisition = Requisition.new
    @requisition.folio = Requisition.count + 1
    @requisition.construction = Construction.find(params[:construction_id])
    if @requisition.save
      redirect_to requisition_path(@requisition)
    end
  end

  def generate_purchase_order
    @requisition = Requisition.find(params[:requisition_id])
    @construction = @requisition.construction
    @purchase_order_count = @construction.purchase_orders.count
    @purchase_order = PurchaseOrder.new
    @purchase_order.folio = @purchase_order_count + 1
    @purchase_order.item_materials<<@requisition.item_materials_not_assigned
    if @purchase_order.save
      redirect_to purchase_order_path(@purchase_order)
    end
  end

end
