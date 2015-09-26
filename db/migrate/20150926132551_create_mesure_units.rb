class CreateMesureUnits < ActiveRecord::Migration
  def change
    create_table :mesure_units do |t|
      t.string :unit
      t.string :abbreviation

      t.timestamps null: false
    end
  end
end
