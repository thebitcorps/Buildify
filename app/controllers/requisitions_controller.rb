class RequisitionsController < ApplicationController
  # before_action :set_requisition, only: [:show, :edit, :update, :destroy]



  def show
    set_requisition
  end

  def new
    @requisition = Requisition.new
    @construction = Construction.find params[:construction]
  end

  def create
    @requisition = Requisition.new requisition_params
    @requisition.folio = Requisition.next_folio @requisition.construction_id
    if @requisition.save!
      redirect_to @requisition ,notice: 'requisition was made:'
    else
      # bug can't add params for the render maybe redirect
      render :new ,construction: params[:requisition][:construction_id]
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_requisition
    @requisition = Requisition.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def requisition_params
    params.require(:requisition).permit(:construction_id)
  end

end
