class ItemMaterialsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_item_material, only: [ :update, :destroy]
  before_action :filter_sub_out
  
  def update
    respond_to do |format|
      if @item_material.update item_material_params
        format.json {render json: @item_material}
      else
        format.json {render json: JSON.parse(@item_material.errors.full_messages.to_json), status: :unprocessable_entity}

      end
    end
  end

  def destroy
    @item_material.destroy
    respond_to do |format|
      format.json { render json: @item_material.to_json, status: :ok }
    end
  end

private
  def set_item_material
    @item_material = ItemMaterial.find(params[:id])
  end


  def item_material_params
    params.require(:item_material).permit(:status,:requested,:measure_unit)
  end
end
