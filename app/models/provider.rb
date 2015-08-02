class Provider < ActiveRecord::Base
  has_many :invoices

  def purchase_orders
    invoices.collect{|invoice| invoice.purchase_orders}.flatten
  end

  def item_materials
    purchase_orders.collect{|purchase_order| purchase_order.item_materials}.flatten
  end

  def requisitions
    purchase_orders.collect{|purchase_order| purchase_order.requisition}.uniq
  end

  def constructions
    requisitions.collect{|requisition| requisition.construction}.uniq
  end

  def invoice_receipts
    InvoiceReceipt.find invoice.collect{|invoice| invoice.invoice_receipt_id}
  end
end
