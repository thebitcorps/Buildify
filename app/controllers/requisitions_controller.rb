class RequisitionsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_requisition, only: [:show, :document, :edit, :update, :destroy]
  before_action :set_construction, only: [:index, :new, :edit]
  before_action :filter_sec_out

  def index
    @petty_cash = PettyCash.with_construction(params[:construction_id]).last
    @type_list = sanitized_locked_param
    if current_user.subordinate?
      if params[:mode] == 'own'
        @requisitions = (class_eval %Q{Requisition.#{@type_list}(#{params[:construction_id]}).page(#{params[:page]})})
      else
        if @type_list == 'all_with_conctruction'
          @requisitions = current_user.all_requisitions(params[:construction_id]).page(params[:page])
        else
          @requisitions = (instance_eval %Q{current_user.#{@type_list}_requisitions(#{params[:construction_id]}).page(#{params[:page]})})
        end
        @mode = 'sub'
      end
    else
      @requisitions = (class_eval %Q{Requisition.#{@type_list}(#{params[:construction_id]}).page(#{params[:page]})})
    end
    respond_to do |format|
      format.html {@requisition}
      format.js
    end
  end

  def show
    @construction = @requisition.construction
    @item_materials = @requisition.item_materials
    # maybe we should add if here if user resident then return json if no return normal?
    @item_materials_json = JSON.parse @requisition.item_materials.to_json( :include => {:material => {:include => :measure_units}})
    @purchase_orders = @requisition.purchase_orders
  end

  def document
  end

  def new
    @requisition = Requisition.new
  end

  def edit
    @item_materials_json = JSON.parse @requisition.item_materials.to_json( :include => {:material => {:include => :measure_units}})
  end

  def create
    @requisition = Requisition.new requisition_params
    @requisition.folio = Requisition.next_folio @requisition.construction_id
    @requisition.creator = current_user
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
    @construction = Construction.find params[:construction_id] if params[:construction_id]
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_requisition
    @requisition = Requisition.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def requisition_params
    params.require(:requisition).permit(:construction_id, :requisition_date, item_materials_attributes: [:material_id, :measure_unit, :requested])
  end


  def sanitized_locked_param
      ['complete','partially','pending'].include?(params[:type_list]) ? params[:type_list] : 'all_with_conctruction'
  end
end
