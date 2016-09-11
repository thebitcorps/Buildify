class RequisitionsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_requisition, only: [:show, :document, :edit, :update, :destroy]
  before_action :set_construction, only: [:index, :new, :edit]

  def index
    @petty_cash = PettyCash.active_from_construction(params[:construction_id])
    @type_list = sanitized_locked_param
    if current_user.subordinate?
      if params[:mode] == 'own'
        @requisitions = (class_eval %Q{Requisition.#{@type_list}.from_construction(#{params[:construction_id]}).page(#{params[:page]})})
      else
        @requisitions = (instance_eval %Q{current_user.requisitions.#{@type_list}.from_construction(#{params[:construction_id]}).page(#{params[:page]})})
        @mode = 'sub'
      end
    else
      @requisitions = (class_eval %Q{Requisition.#{@type_list}.from_construction(#{params[:construction_id]}).page(#{params[:page]})})
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
    @item_materials_json = JSON.parse @requisition.item_materials.to_json( include: { material: { include: :measure_units } } )
    @purchase_orders = @requisition.purchase_orders
  end

  def document
  end

  def new
    @requisition = Requisition.new
  end

  def edit
    @item_materials_json = JSON.parse @requisition.item_materials.to_json( include: { material: { include: :measure_units } } )
  end

  def create
    @requisition = Requisition.new requisition_params
    @requisition.creator = current_user
    respond_to do |format|
      if @requisition.save
        @requisition.sent! if params[:requisition][:status] == 'sent'
        format.json {render json: @requisition}
        format.html {redirect_to @requisition, notice: 'requisition was made'}
      else
        # bug can't add params for the render maybe redirect #what?!
        format.json {render json: JSON.parse(@requisition.errors.full_messages.to_json), status: :unprocessable_entity }
      end
    end
  end

  # only use for sending requisiton for revision
  def update
    if @requisition.sent!
      redirect_to @requisition, notice: 'La requisición fue cerrada.'
    else
      redirect_to @requisition, alert: @requisition.errors.full_message
    end
  end

  def destroy
    if @requisition.empty?
      if @requisition.destroy
        redirect_to requisitions_path(construction_id: @requisition.construction_id), notice: 'Requisicion borrada correctamente'
      else
        redirect_to @requisition,alert: 'No fue posible realizar accion.'
      end
    else
      redirect_to @requisition, alert: 'Requisicion tiene materiales. No es posible borrarla'
    end
  end

  private

  def set_construction
    @construction = Construction.find params[:construction_id] if params[:construction_id]
  end

  def set_requisition
    @requisition = Requisition.find(params[:id])
  end

  def requisition_params
    params.require(:requisition).permit(:construction_id, :requisition_date, item_materials_attributes: [:material_id, :measure_unit, :requested])
  end

  def sanitized_locked_param
      ['complete','partially','pending','sent'].include?(params[:type_list]) ? params[:type_list] : 'all'
  end
end
