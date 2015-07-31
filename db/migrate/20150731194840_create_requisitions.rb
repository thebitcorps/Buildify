class CreateRequisitions < ActiveRecord::Migration
  def change
    create_table :requisitions do |t|
      t.references :construction, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
