class PurchaseOrdersController < ApplicationController

  def show
    @purchase_order = PurchaseOrder.find(params[:id])
    @item_materials = @purchase_order.item_materials
    @requisition = @purchase_order.requisition
    @construction = @requisition.construction if @requisition
  end

  def update_item_materials
    @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
    @requisition = purchase_order.requisition
    @item_materials_to_remove = material_items_params[:item_materials_attributes].delete_if{|_,v| v["_destroy"] == "0"}.values.map{|h| h[:id]}
    if @purchase_order.update(material_items_params)
      @item_materials = ItemMaterial.find @item_materials_to_remove
      @item_materials.each do |item|
        item.status ='En requisicion'
        item.unit_price = nil;
      end
      @purchase_order.item_materials.delete @item_materials
      if @purchase_order.item_materials.blank?
        @purchase_order.destroy
        redirect_to requisition_path(@requisition)
      else
        redirect_to purchase_order_path(@purchase_order)
      end
    end
  end

  private

    def material_items_params
      params.require(:purchase_order).permit(item_materials_attributes: [:id, :unit_price, :_destroy])
    end

end
