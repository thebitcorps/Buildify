class EstimatesController < ApplicationController
  before_action :set_construction, only: [:new, :index]

  def index
    @estimates = Estimate.where(construction_id: @construction)
  end

  def new
    @estimate = Estimate.new
    @estimate.construction = @construction
  end

  def create
    @estimate = Estimate.new(estimate_params)
    respond_to do |format|
      if @estimate.save
        @estimate.construction.estimates_amount += @estimate.amount
        @estimate.construction.save
        format.html { redirect_to @estimate.construction, notice: 'Estamacion agragada a la obra.'}
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @estimate = Estimate.find(params[:id])
    @construction = @estimate.construction
    @construction.estimates_amount -= @estimate.amount
    @construction.save
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
      params.require(:estimate).permit(:amount, :payment_date, :construction_id)
    end

end