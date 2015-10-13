class CreateConstructionUsers < ActiveRecord::Migration
  def change
    create_table :construction_users do |t|
      t.references :construction, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :role,defalt: 'resident'

      t.timestamps null: false
    end
  end
end
