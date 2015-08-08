class InvoiceReceiptsController < ApplicationController

  def create
    @invoice_receipt = InvoiceReceipt.new
    @invoice_receipt.folio = InvoiceReceipt.count + 1
    if @invoice_receipt.save
      redirect_to invoice_receipt_path(@invoice_receipt)
    end
  end

  def show
    @invoice_receipt = InvoiceReceipt.find(params[:id])
    @invoice = Invoice.new
    @invoices = @invoice_receipt.invoices
    @providers = Provider.all
  end

  def update
    @invoice_receipt = InvoiceReceipt.find(params[:id])
    @invoice_receipt.provider = Provider.find(provider_params[:provider_id]) if provider_params[:provider_id] != ""
    if @invoice_receipt.save
      redirect_to invoice_receipt_path(@invoice_receipt)
    end
  end

  private

    def provider_params
      params.require(:invoice_receipt).permit(:provider_id)
    end
end
