class ConstructionsController < ApplicationController

  def index
    @constructions = Construction.all
  end

  def show
    @construction = Construction.find(params[:id])
    @expenses = @construction.expenses
  end

  def new
    @construction = Construction.new
  end

  def create
    @construction = Construction.new(construction_params)
    if @construction.save
      redirect_to constructions_path
    end
  end

  private

    def construction_params
      params.require(:construction).permit(:title, :contract_amount, :current_amount, :start_date, :finish_date)
    end

end
