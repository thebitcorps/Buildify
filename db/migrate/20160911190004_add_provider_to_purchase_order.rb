class AddProviderToPurchaseOrder < ActiveRecord::Migration
  def change
    add_reference :purchase_orders ,:provider
    Invoice.find_each do |invoice|
      invoice.purchase_order.provider_id = invoice.provider_id
      invoice.purchase_order.save
    end
  end
end
