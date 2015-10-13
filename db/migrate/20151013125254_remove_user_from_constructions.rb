class RemoveUserFromConstructions < ActiveRecord::Migration
  def change
    remove_reference :constructions, :user, index: true, foreign_key: true
  end
end
