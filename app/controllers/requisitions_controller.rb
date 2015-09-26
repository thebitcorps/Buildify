class RequisitionsController < ApplicationController
  before_action :set_requisition, only: [:show, :edit, :update, :destroy]
  before_action :set_construction, only: [:index, :new, :edit]

  def index
    @requisitions = Requisition.where(construction_id: params[:construction_id])
  end

  def show
    @construction = @requisition.construction
    @item_materials = @requisition.item_materials
    @purchase_orders = @requisition.purchase_orders
  end

  def new
    @requisition = Requisition.new
  end

  def edit
  end

  def create
    @requisition = Requisition.new requisition_params
    @requisition.folio = Requisition.next_folio @requisition.construction_id
    respond_to do |format|
      if @requisition.save
        format.json {render json: @requisition}
        format.html {redirect_to @requisition, notice: 'requisition was made'}
      else
        # bug can't add params for the render maybe redirect #what?!
        format.json {render json: JSON.parse(@requisition.errors.full_messages.to_json), status: :unprocessable_entity }
      end
    end
  end

  private

  def set_construction
    @construction = Construction.find params[:construction_id]
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_requisition
    @requisition = Requisition.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def requisition_params
    params.require(:requisition).permit(:construction_id, :requisition_date, item_materials_attributes: [:material_id, :measure_unit, :requested])
  end

end
