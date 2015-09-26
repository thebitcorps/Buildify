class CreatePermittedMesureUnits < ActiveRecord::Migration
  def change
    create_table :permitted_mesure_units do |t|
      t.references :material, index: true, foreign_key: true
      t.references :mesure_unit, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
