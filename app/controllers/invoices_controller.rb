class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def upfate
  end

  private

  def set_invoice
    @invoice = Invoice.find params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def requisition_params
    params.require(:invoice).permit(:folio, :amount, :invoice_date)
  end
end
