class AddTypeToConstruction < ActiveRecord::Migration
  def change
    add_column :constructions, :type, :string
  end
end
