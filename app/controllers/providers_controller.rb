  class ProvidersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_provider, only: [ :show, :edit, :destroy, :update ]
  # before_action :filter_sub_out

  def index
    @providers = Provider.all_alphabetical.search(params[:search]).page(params[:page])
    respond_to do |format|
      format.html {@providers}
      format.json { render :index}
      format.js {@providers}
    end
  end

  def new
    @provider = Provider.new
  end

  def edit
  end

  # we show add @provider_purchase order so we can show similar as in the user the purchse_order of the correspondly provider
  def show
    @missing_attributes = @provider.attributes.select { |key,value| key if value.blank? }
  end

  def create
    @provider = Provider.new(provider_params)
    respond_to do |format|
      if @provider.save
        format.html { redirect_to @provider, notice: 'Proveedor creado correctamente.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @provider.update(provider_params)
        format.html { redirect_to @provider, notice: 'Proveedor actualizado.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @provider.destroy
    respond_to do |format|
      format.html { redirect_to providers_path, notice: 'Proveedor eliminado.' }
    end
  end

private
  def set_provider
    @provider = Provider.find params[:id]
  end

  def provider_params
    params.require(:provider).permit(:name, :zipcode, :neighborhood, :number, :city , :street, :telephone, :email, :nickname)
  end

end
