class ConstructionsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_action :set_construction, only: [:show, :edit, :update, :destroy]
  # before_action :humanize_title, only: [:create, :update]

  def index
    if current_user.subordinate?
      params[:mode] = params[:search][:mode] if !params[:search].nil?
      if params[:mode] == 'own'
        @constructions =  current_user.construction_administrations.search(params[:search]).page(params[:page])
        @mode = :own
      else
        @constructions =  current_user.constructions.search(params[:search]).page(params[:page])
        @mode = :sub
      end
    else
      @constructions = instance_eval("Construction.search(params[:search]).page(params[:page]).#{sanitize_status}")
      @mode = :all
    end
    respond_to do |format|
      format.html {@constructions}
      format.js {@constructions}
    end
  end

  def show
    @payments = @construction.payments.page(params[:payment_page])
  end

  def new
    @construction = Construction.new
  end

  def create
    @construction = Construction.new construction_params
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
    def sanitize_status
      return 'all' if params[:status].nil? or params[:status].to_sym == :all
      if Construction::STATUS.include? params[:status].to_sym
        params[:status]
      else
        'running'
      end
    end

    def humanize_title
      params[:construction][:title] = params[:construction][:title].split.map(&:capitalize).join(' ')
    end

    def set_construction
      @construction = Construction.find(params[:id])
    end

    def construction_params
      params.require(:construction).permit(:title, :start_date,:address, :status,:finish_date, :contract_amount, :user_id, construction_users_attributes: [:id,:user_id,:role,:_destroy])
    end

end
