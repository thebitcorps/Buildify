class CreateItemMaterials < ActiveRecord::Migration
  def change
    create_table :item_materials do |t|
      t.decimal :requested
      t.decimal :recived
      t.string :status
      t.decimal :quiantity
      t.decimal :unit_price
      t.references :requisition, index: true, foreign_key: true
      t.references :purchase_order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
