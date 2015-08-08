class PurchaseOrdersController < ApplicationController

  def show
    @purchase_order = PurchaseOrder.find(params[:id])
    @item_materials = @purchase_order.item_materials
    @requisition = @purchase_order.requisition
    @construction = @requisition.construction if @requisition
    @providers = Provider.all
  end

  def update
    @purchase_order = PurchaseOrder.find(params[:id])
    @purchase_order.provider = Provider.find(provider_params[:provider_id]) if provider_params[:provider_id] != ""
    if @purchase_order.update(purchase_order_params)
      redirect_to purchase_order_path(@purchase_order)
    end
  end

  def update_item_materials
    @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
    @requisition = @purchase_order.requisition
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

    def purchase_order_params
      params.require(:purchase_order).permit(:delivery_place, :delivery_address, :delivery_receiver)
    end

    def provider_params
      params.require(:purchase_order).permit(:provider_id)
    end

    def material_items_params
      params.require(:purchase_order).permit(item_materials_attributes: [:id, :recived, :unit_price, :_destroy])
    end

end
