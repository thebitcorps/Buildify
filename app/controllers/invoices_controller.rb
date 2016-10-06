class InvoicesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_invoice, only: [:show, :document, :edit, :update]

  def index
    @invoices = Invoice.includes(:provider).where(id: get_payments_ids)
    # is okay to use find because all id are valid
    respond_to do |format|
      format.json{render :index}
    end
  end

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new invoice_params
    purchase_order = PurchaseOrder.find params[:purchase_order_id]
    @invoice.provider_id = purchase_order.provider_id
    @invoice.construction_id = purchase_order.construction.id
    respond_to do  |format|
      if @invoice.save
        build_payment(@invoice, purchase_order)
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
        format.html {render :edit, notice: 'Error' }
        format.json {render json: JSON.parse(@invoice.errors.full_messages.to_json), status: :unprocessable_entity}
      end
    end
  end

  private

  def get_payments_ids
    if params[:purchase_order_id].blank?
      ids = Construction.running.pluck(:id)
      Payment.where(construction_id: ids).pluck(:invoice_id)
    else
      Payment.from_purchase_order(params[:purchase_order_id]).pluck(:invoice_id)
    end
  end


  def build_payment(invoice, purchase_order)
    Payment.create(invoice_id: invoice.id, amount: invoice.amount, payment_date: invoice.invoice_date, construction_id: purchase_order.construction.id, purchase_order_id: purchase_order.id)
  end

  def set_invoice
    @invoice = Invoice.find params[:id]
    @invoice.status = Invoice::ADDED_STATUS
  end

  def invoice_params
    params.require(:invoice).permit(:receipt_folio, :amount, :invoice_date, :purchase_order_id, :provider_id, :observations)
  end
end
