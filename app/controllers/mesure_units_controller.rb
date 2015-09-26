class MesureUnitsController < ApplicationController
  before_action :set_mesure_unit, only: [:show, :edit, :update, :destroy]

  def index
    @mesure_units = MesureUnit.all
  end

  def show
  end

  def new
    @mesure_unit = MesureUnit.new
  end

  def edit
  end

  def create
    @mesure_unit = MesureUnit.new(mesure_unit_params)

    respond_to do |format|
      if @mesure_unit.save
        format.html { redirect_to @mesure_unit, notice: 'Mesure unit was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @mesure_unit.update(mesure_unit_params)
        format.html { redirect_to @mesure_unit, notice: 'Mesure unit was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @mesure_unit.destroy
    respond_to do |format|
      format.html { redirect_to mesure_units_url, notice: 'Mesure unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mesure_unit
      @mesure_unit = MesureUnit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mesure_unit_params
      params.require(:mesure_unit).permit(:unit, :abbreviation)
    end
end
