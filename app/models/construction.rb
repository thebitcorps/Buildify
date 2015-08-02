class Construction < ActiveRecord::Base
  has_many :requisitions

  def purchase_orders
    requisitions.collect{|requisition| requisition.purchase_orders}.flatten
  end

  def invoices
    Invoice.find purchase_orders.map(&:invoice_id)
  end

  def expenses
    invoices.collect{|invoice| invoice.expense}.compact
  end
end
