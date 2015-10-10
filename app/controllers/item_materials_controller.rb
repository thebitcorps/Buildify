class ItemMaterialsController < ApplicationController

  def update
    set_item_material
    respond_to do |format|
      if @item_material.update item_material_params
        format.json {render json: @item_material}
      else
        format.json {render json: JSON.parse(@item_material.errors.full_messages.to_json), status: :unprocessable_entity}

      end
    end
  end

private
  def set_item_material
    @item_material = ItemMaterial.find(params[:id])
  end

  def item_material_params
    params.require(:item_material).permit(:status)
  end
end
