class AddFormatedFolioToPurchaseOrders < ActiveRecord::Migration
  def change
    add_column :purchase_orders, :formated_folio, :string
  end
end
