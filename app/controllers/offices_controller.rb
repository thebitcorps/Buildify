class OfficesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_office, only: [:show, :edit, :update, :destroy]
  # before_action :filter_sec_out
  # before_action :filter_sub_out

  def new
    @office = Office.new
  end

  def show
    @payments = @office.payments
  end

  def edit
  end

  def create
    @office = Office.new office_params
    if @office.save
      redirect_to @office, notice: 'Nueva oficina creada.'
    else
      render :new
    end
  end

  def update
    if @office.update office_params
      redirect_to @office, notice: 'Oficina modificada.'
    else
      render :edit
    end
  end

  private
  def set_office
    @office = Office.find params[:id]
  end

  def office_params
    params.require(:office).permit(:start_date, :finish_date)
  end
end
