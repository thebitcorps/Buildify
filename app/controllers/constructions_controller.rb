class ConstructionsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_construction, only: [:show, :edit, :update, :destroy]
  before_action :filter_sub_out, only: [:edit, :update, :destroy]
  # before_action :humanize_title, only: [:create, :update]

  def index
    if current_user.subordinate?
      if params[:mode].nil? || params[:mode] == 'own' || params[:search][:mode] == 'own'
        @constructions =  current_user.construction_administrations.search(sanitized_search).page(params[:page])
        @mode = :own
      else
        @constructions =  current_user.constructions.search(sanitized_search).page(params[:page])
        @mode = :sub
      end
    else
      @constructions = Construction.search(sanitized_search).page(params[:page])
      @mode = :all
    end
    respond_to do |format|
      format.html {@constructions}
      format.js {@constructions}
    end
  end

  def show
    @payments = @construction.payments
  end

  def new
    @construction = Construction.new
  end

  def create
    @construction = Construction.new(construction_params)
    respond_to do |format|
      if @construction.save
        format.html { redirect_to @construction, notice: 'Registro de obra creado correctamente.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @construction.update construction_params
        format.html { redirect_to @construction, notice: 'El registro de la obra fue actualizado correctamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  private
    def humanize_title
      params[:construction][:title] = params[:construction][:title].split.map(&:capitalize).join(' ')
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_construction
      @construction = Construction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def construction_params
      params.require(:construction).permit(:title, :start_date,:address, :status,:finish_date, :contract_amount,construction_users_attributes: [:user_id,:role,:_destroy])
    end

end
