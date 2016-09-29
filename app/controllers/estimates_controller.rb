class EstimatesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_construction, only: [:new, :index]

  def index
    @estimates = @construction.estimates
    # @estimates = Estimate.where(construction: @construction)
  end

  def new
    @estimate = Estimate.new(construction: @construction)
    # @estimate.construction = @construction
  end

  def create
    @estimate = Estimate.new(estimate_params)
    respond_to do |format|
      if @estimate.save
        format.html { redirect_to @estimate.construction, notice: 'Extension agregada a la obra.'}
      else
        @construction = @estimate.construction
        format.html { render :new}
      end
    end
  end

  def update
    respond_to do |format|
      if @estimate.update payment_date: params[:estimate][:payment_date]
        @estimate.complete!
        format.json { render json: @estimate.to_json}
      else
        format.json{ @estimte.errors.full_messages.to_json}
      end
    end
  end

  def destroy
    @estimate = Estimate.find(params[:id])
    @construction = @estimate.construction
    @estimate.destroy
    respond_to do |format|
      format.html { redirect_to estimates_path(construction_id: @construction), notice: 'Estimacion elimina correctamente.' }
    end
  end

  private
    def set_construction
      @construction = Construction.find(params[:construction_id])
    end

    def estimate_params
      params.require(:estimate).permit(:amount, :extension_date, :construction_id, :concept)
    end
end
