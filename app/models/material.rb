class Material < ActiveRecord::Base
  has_many :item_materials

  def purchase_orders
    PurchaseOrder.find item_materials.map(&:purchase_order_id)
  end

  def requisitions
    Requisition.find item_materials.map(&:requisition_id)
  end

  def constructions
    Construction.find requisitions.map(&:construction_id)
  end

  def invoices
    Invoice.find purchase_orders.map(&:invoice_id)
  end

  def expenses
    Expense.find invoices.map(&:expense_id)
  end

  def invoice_receipts
    InvoiceReceipt.find invoices.map(&:invoice_receipt_id)
  end

  def providers
    Provider.find invoices.map(&:provider_id)
  end

end
