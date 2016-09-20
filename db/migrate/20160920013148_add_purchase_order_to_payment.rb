class AddPurchaseOrderToPayment < ActiveRecord::Migration
  def change
    add_reference :payments, :purchase_order,index: true
    add_reference :payments, :invoice, index: true
    add_reference :invoices, :construction, index: true
    Invoice.find_each do |invoice|
      payment = invoice.payment
      payment.purchase_order_id = invoice.purchase_order.id
      payment.invoice_id = invoice.id
      payment.save
    end
  end
end
