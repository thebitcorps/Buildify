class ItemMaterialsController < ApplicationController

  def create
    @item_material = ItemMaterial.new(item_material_params)
    @item_material.construction = Construction.find(owners_params[:construction_id])
    @item_material.material = Material.find(owners_params[:material_id])
    @item_material.requisition = Requisition.find(owners_params[:requisition_id])
    @item_material.status = 'En requisicion'
    if @item_material.save
      redirect_to requisition_path(@item_material.requisition)
    end
  end

    def item_material_params
      params.require(:item_material).permit(:requested)
    end

    def owners_params
      params.require(:item_material).permit(:material_id, :requisition_id, :construction_id)
    end

end
