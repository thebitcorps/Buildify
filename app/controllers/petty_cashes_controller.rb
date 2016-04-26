class PettyCashesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_petty_cash, only: [:show, :edit, :update, :destroy]
  # before_action :filter_sec_out
  # before_action :filter_sub_out, only: [:destroy,:edit]

  def index
    @construction = Construction.find params[:construction_id]
    @petty_cashes = PettyCash.with_construction params[:construction_id]
  end

  def show
  end


  def edit
  end

  def create
    @petty_cash = PettyCash.new(petty_cash_params)

    respond_to do |format|
      if @petty_cash.save
        format.json { render :show, status: :created, location: @petty_cash }
      else
        format.json { render json: @petty_cash.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @petty_cash.update(petty_cash_params)
        format.html { redirect_to @petty_cash, notice: 'Petty cash was successfully updated.' }
        format.json { render :show, status: :ok, location: @petty_cash }
      else
        format.html { render :edit }
        format.json { render json: @petty_cash.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @petty_cash.destroy
    respond_to do |format|
      format.html { redirect_to petty_cashes_url, notice: 'Petty cash was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_petty_cash
      @petty_cash = PettyCash.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def petty_cash_params
      params.require(:petty_cash).permit(:closing_date, :construction_id, :amount)
    end
end
