class AddFormatedFolioToRequisitions < ActiveRecord::Migration
  def change
    add_column :requisitions, :formated_folio, :string
  end
end
