class MaterialsController < ApplicationController
  before_action :set_material, only: [:show,:edit,:destroy,:update]
  before_action :humanize_material,only: [:create,:update]

  def index
    @materials = Material.all_alphabetical
  end

  def new
    @material = Material.new
  end

  def edit
  end

  def show
  end

  def create
    @material = Material.new material_params
    respond_to do |format|
      if @material.save!
        format.html { redirect_to @material, notice: 'Registro de material creado correctamente.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @material.update(material_params)
        format.html { redirect_to @material, notice: 'Material was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @material.destroy
    respond_to do |format|
      format.html { redirect_to materials_path, notice: 'Material was successfully destroyed.' }
    end
  end

private

  def humanize_material
    params[:material][:name] = params[:material][:name].split.map(&:capitalize).join(' ')
  end

  def set_material
    @material = Material.find params[:id]
  end

  def material_params
    params.require(:material).permit(:name,:description)
  end
end
