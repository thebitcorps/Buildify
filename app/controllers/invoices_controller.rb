class InvoicesController < ApplicationController

  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.invoice_receipt = InvoiceReceipt.find(owners_params[:invoice_receipt_id])
    if @invoice.save
      redirect_to invoice_receipt_path(@invoice.invoice_receipt)
    end
  end

  def show
    @invoice = Invoice.find(params[:id])
    @purchase_orders = @invoice.purchase_orders
    @available_purchase_orders = PurchaseOrder.where(invoice_id: nil, provider_id: @invoice.provider.id)
  end

  def add_purchase_order
    @invoice = Invoice.find(params[:invoice_id])
    @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
    @purchase_order.invoice = @invoice
    if @purchase_order.save
      redirect_to invoice_path(@invoice)
    end
  end

  def remove_purchase_order
    @invoice = Invoice.find(params[:invoice_id])
    @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
    @purchase_order.invoice = nil
    if @purchase_order.save
      redirect_to invoice_path(@invoice)
    end
  end

  private

    def invoice_params
      params.require(:invoice).permit(:folio, :amount, :reg_date)
    end

    def owners_params
      params.require(:invoice).permit(:invoice_receipt_id)
    end
end
