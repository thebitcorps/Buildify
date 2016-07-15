class InvoicesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_invoice, only: [:show, :document, :edit, :update]

  def show
    redirect_to document_invoice_path(@invoice)
  end

  def edit
  end

  def document
  end

  def update
    respond_to do |format|
      if @invoice.update invoice_params
        format.html { redirect_to @invoice.construction, notice: 'Factura actualizada.' }
      else
        format.html { render :edit, notice: 'Error' }
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
