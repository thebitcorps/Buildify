class CreatePermittedMeasureUnits < ActiveRecord::Migration
  def change
    create_table :permitted_measure_units do |t|
      t.references :material, index: true, foreign_key: true
      t.references :measure_unit, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
