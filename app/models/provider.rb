class Provider < ActiveRecord::Base
  has_many :invoices_receipts
  has_many :purchase_orders

  def invoices
    invoice_receipts.collect{|invoice_receipts| invoice_receipt.invoices}
  end

  def requisitions
    purchase_orders.collect{|purchase_order| purchase_order.requisition}.uniq
  end

  def constructions
    requisitions.collect{|requisition| requisition.construction}.uniq
  end

end
