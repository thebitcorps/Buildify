class AddConceptToExtension < ActiveRecord::Migration
  def change
    add_column :estimates, :concept, :string
    add_column :estimates, :extension_date, :date
    add_column :estimates, :status, :string
  end
end
