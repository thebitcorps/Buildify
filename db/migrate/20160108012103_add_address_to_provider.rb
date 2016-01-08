class AddAddressToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :zipcode, :string,default: ''
    add_column :providers, :street, :string,default: ''
    add_column :providers, :neighborhood, :string,default: ''
    add_column :providers, :number, :string,default: ''
    add_column :providers, :city, :string,default: ''
    remove_column :providers,:address,:string
  end
end
