class AddLockeableToUser < ActiveRecord::Migration
  def change

    add_column :users,  :failed_attempts,:integer, default: 0, null: false # Only if lock strategy is :failed_attempts
    add_column :users,  :unlock_token,:string
    add_column :users,  :locked_at,:datetime

  end
end
