class MaterialsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_material, only: [:show, :edit, :destroy, :update]

  def index
    @materials = class_eval("Material.#{sanitize_type_list}")
    @materials = @materials.search(params[:search]).page(params[:page])
    respond_to do |format|
      # the order in html and js response if for ordering
      format.json { render json: @materials, include: :measure_units}
      format.html {@materials = @materials.order(name: :asc)}
      format.js {@materials = @materials.order(name: :asc)}
    end
  end

  def new
    @material = Material.new
    @measure_units = MeasureUnit.all
  end

  def edit
  end

  def show
  end

  def create
    @material = Material.new(material_params)
    respond_to do |format|
      if @material.save
        format.html { redirect_to @material, notice: 'Material creado correctamente.'}
        format.json {render json: @material.to_json(:include => :measure_units)}
      else
        format.html { render :new }
        format.json {render json: JSON.parse(@material.errors.full_messages.to_json), status: :unprocessable_entity}
      end
    end
  end

  def update
    respond_to do |format|
      if @material.update(material_params)
        format.html { redirect_to @material, notice: 'Material actualizado.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @material.destroy
    respond_to do |format|
      format.html { redirect_to materials_path, notice: 'Material eliminado.' }
    end
  end

private

  def sanitize_type_list
    ['all','pending'].include?(params[:type_list]) ? params[:type_list] : 'all'
  end


  def humanize_material
    params[:material][:name] = params[:material][:name].split.map(&:capitalize).join(' ')
  end

  def set_material
    @material = Material.find params[:id]
  end

  def material_params
    params.require(:material).permit(:name, :description,:measure_unit_ids => [])
  end
end
