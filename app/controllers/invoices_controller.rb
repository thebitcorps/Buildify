class InvoicesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_invoice, only: [:show, :document, :edit, :update]

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new invoice_params
    if build_against_receipt(@invoice)
      respond_to do  |format|
        if @invoice.save
            build_against_receipt(@invoice)
          format.json {render :show ,status: :ok, location: @invoice}
        else
          format.json {render json: JSON.parse(@invoice.errors.full_messages.to_json), status: :unprocessable_entity}
        end
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
  def build_against_receipt(invoice)
    AgainstReceipt.create invoice_id: invoice.id,purchase_order_id: params[:purchase_order_id].to_i
  end

  def set_invoice
    @invoice = Invoice.find params[:id]
    @invoice.status = Invoice::ADDED_STATUS
  end

  def invoice_params
    params.require(:invoice).permit(:receipt_folio, :amount, :invoice_date, :purchase_order_id)
  end
end
