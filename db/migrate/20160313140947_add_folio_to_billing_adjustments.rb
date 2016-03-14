class AddFolioToBillingAdjustments < ActiveRecord::Migration
  def change
    add_column :billing_adjustments, :folio, :string
    add_column :billing_adjustments, :check_number, :string
    add_column :billing_adjustments, :account, :string
    rename_column :billing_adjustments,:adjusment_date,:adjustment_date
  end
end
