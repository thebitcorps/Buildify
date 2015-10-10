  class ProvidersController < ApplicationController
  before_action :set_provider, only: [:show,:edit,:destroy,:update]

  def index
    @providers = Provider.all_alphabetical.search(sanitized_search).page(params[:page])
    respond_to do |format|
      format.html {@providers}
      format.json { render json: @providers}
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
    params.require(:provider).permit(:name, :address, :telephone, :email)
  end

end
