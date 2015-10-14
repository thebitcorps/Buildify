class AddUserToConstruction < ActiveRecord::Migration
  def change
    add_reference :constructions, :user, index: true, foreign_key: true
  end
end
