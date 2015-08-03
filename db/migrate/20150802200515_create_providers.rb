class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name
      t.string :address
      t.string :telephone

      t.timestamps null: false
    end
  end
end
