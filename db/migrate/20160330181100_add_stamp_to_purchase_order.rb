class AddStampToPurchaseOrder < ActiveRecord::Migration
  def change
    add_column :purchase_orders, :stamp, :string
    add_column :purchase_orders, :authorizer_id, :integer
    add_column :purchase_orders, :stamp_date, :date
  end
end
