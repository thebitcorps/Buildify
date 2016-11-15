class AddNicknameToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :nickname , :string
  end
end
