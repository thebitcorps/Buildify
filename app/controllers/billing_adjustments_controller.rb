class BillingAdjustmentsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_payment, only: [:new, :index]

  def index
    @adjustments = @payment.billing_adjustments
    respond_to do |format|
      format.html {}
      format.json {render :index}
    end

  end

  def new
    @adjustment = BillingAdjustment.new
  end

  def create
    @adjustment = BillingAdjustment.new adjustment_params
    @payment = @adjustment.payment
    respond_to do |format|
      if @adjustment.save
        #remember callbacks
        format.html { redirect_to @adjustment.payment.construction, notice: 'Pago realizado a gasto.'}
        format.json{ render :show ,status: :ok, location: @adjustment }
      else
        format.html { render :new }
        format.json { render json: JSON.parse(@adjustment.errors.full_messages.to_json), status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @adjustment = BillingAdjustment.find(params[:id])
    #remember callbacks for update payment
    @adjustment.destroy
    respond_to do |format|
      format.html { redirect_to billing_adjustments_path(payment_id: @adjustment.payment.id), notice: 'Pago eliminado correctamente.' }
    end
  end

  private
    def set_payment
      @payment = Payment.find(params[:payment_id])
    end

    def adjustment_params
      params.require(:billing_adjustment).permit(:amount, :payment_type, :adjustment_date, :payment_id,:reference,:account,:folio)
    end
end