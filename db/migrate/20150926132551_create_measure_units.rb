class CreateMeasureUnits < ActiveRecord::Migration
  def change
    create_table :measure_units do |t|
      t.string :unit
      t.string :abbreviation

      t.timestamps null: false
    end
  end
end
