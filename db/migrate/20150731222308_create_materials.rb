class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :name
      t.string :description
      t.string :measure_unit

      t.timestamps null: false
    end
  end
end