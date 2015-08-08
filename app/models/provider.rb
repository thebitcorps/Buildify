class Provider < ActiveRecord::Base
  has_many :invoices_receipts

  def invoices
    invoice_receipts.collect{|invoice_receipts| invoice_receipt.invoices}
  end

  def purchase_orders
    invoices.collect{|invoice| invoice.purchase_orders}
  end

  def requisitions
    purchase_orders.collect{|purchase_order| purchase_order.requisition}.uniq
  end

  def constructions
    requisitions.collect{|requisition| requisition.construction}.uniq
  end

end
