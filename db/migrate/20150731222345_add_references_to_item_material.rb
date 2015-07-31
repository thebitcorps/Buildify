class AddReferencesToItemMaterial < ActiveRecord::Migration
  def change
    add_reference :item_materials, :material, index: true, foreign_key: true
  end
end
