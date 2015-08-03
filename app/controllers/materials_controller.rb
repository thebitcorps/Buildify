class MaterialsController < ApplicationController

  def index
    @materials = Material.all
  end

  def show
    @material = Material.find(params[:id])
  end

  def new
    @material = Material.new
  end

  def create
    @material = Material.new(material_params)
    if @material.save
      redirect_to materials_path
    end
  end

  private

    def material_params
      params.require(:material).permit(:name, :description, :measure_unit)
    end

end
