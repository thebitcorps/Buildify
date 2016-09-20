class InvoicesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_invoice, only: [:show, :document, :edit, :update]

  def index
    if params[:purchase_order_id]
      invoice_ids = Payment.from_purchase_order(params[:purchase_order_id]).pluck(:invoice_id)
      # is okay to use find because all id are valid 
      @invoice = Invoice.find invoice_ids
    else
      @invoices = Invoice.all
    end
    respond_to do |format|
      format.json {render :index}
    end
  end

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new invoice_params
    respond_to do  |format|
      if @invoice.save
        build_payment(@invoice)
        format.json {render :show ,status: :ok, location: @invoice}
      else
        format.json {render json: JSON.parse(@invoice.errors.full_messages.to_json), status: :unprocessable_entity}
      end
    end
  end


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
        format.json {render :show ,status: :ok, location: @invoice}
      else
        format.html { render :edit, notice: 'Error' }
        format.json {render json: JSON.parse(@invoice.errors.full_messages.to_json), status: :unprocessable_entity}
      end
    end
  end

  private
  def build_payment(invoice)
    purchase_order = PurchaseOrder.find params[:purchase_order_id]
    Payment.create(invoice_id: invoice.id, amount: invoice.amount, payment_date: invoice.invoice_date, construction_id: purchase_order.construction.id, purchase_order_id: purchase_order.id)
  end

  def set_invoice
    @invoice = Invoice.find params[:id]
    @invoice.status = Invoice::ADDED_STATUS
  end

  def invoice_params
    params.require(:invoice).permit(:receipt_folio, :amount, :invoice_date, :purchase_order_id)
  end
end
