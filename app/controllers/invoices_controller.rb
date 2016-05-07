class InvoicesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_invoice, only: [:show, :document, :edit, :update]

  def show
  end

  def edit
  end

  def document
  end

  def update
    respond_to do |format|
      if @invoice.update invoice_params
        @invoice.build_payment if @invoice.payment.nil? && !@invoice.amount.blank?
        #here we have repetition of fields
        #maybe get this value always from the invoice to prevent repetition
        @invoice.payment.amount = @invoice.amount
        @invoice.payment.payment_date = @invoice.invoice_date
        @invoice.payment.construction = @invoice.construction
        @invoice.save # este método no es correcto en la actualización
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

  def invoice_params
    params.require(:invoice).permit(:folio, :amount, :invoice_date)
  end
end
