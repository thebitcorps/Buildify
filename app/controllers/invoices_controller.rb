class InvoicesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_invoice, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @invoice.update invoice_params
        @invoice.build_payment if @invoice.payment == nil && !@invoice.amount.blank?
        #here we have repetition of fields
        #maybe get this value always from the invoice to prevent repetition
        @invoice.payment.amount = @invoice.amount
        @invoice.payment.payment_date = @invoice.invoice_date
        @invoice.payment.construction = @invoice.construction
        @invoice.save
        format.html { redirect_to @invoice.construction, notice: 'Factura actualizada.' }
      else
        format.html { render :edit }
      end
    end
  end

  private

  def set_invoice
    @invoice = Invoice.find params[:id]
    @invoice.status = Invoice::ADDED_STATUS
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def invoice_params
    params.require(:invoice).permit(:folio, :amount, :invoice_date)
  end
end
