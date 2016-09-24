class PaymentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @type_list = sanitized_type_list
    respond_to do |format|
      format.html {redirect_to construction_path(params[:construction_id]),type_list: params[:type_list]}
      @payments =(class_eval %Q{Payment.#{@type_list}(#{params[:construction_id]}).page(#{params[:payment_page]})})
      format.js {@payments}
      format.json {render :index}
    end

  end

  def create
    @payment = Payment.new payment_params
    respond_to do |format|
      if @payment.save
         format.json{ render :show ,status: :ok, location: @payment }
      else
        format.json { render json: JSON.parse(@payment.errors.full_messages.to_json), status: :unprocessable_entity}

      end
    end
  end

  private
  def payment_params
    params.require(:payment).permit(:amount,:concept,:payment_date,:construction_id,:invoice_id,:purchase_order_id)
  end

  def sanitized_type_list
    Payment::STATUS.include?(params[:type_list]) ? params[:type_list] : 'all_construction'
  end
end
