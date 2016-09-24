class CreateFolioCounters < ActiveRecord::Migration
  def change
    create_table :folio_counters do |t|
      t.integer :year, default: Date.today::year
      t.integer :count, default: 0
    end
    Invoice.all.order('created_at ASC').each do |invoice|
      invoice.receipt_folio = invoice.folio
      invoice.folio = FolioCounter.get_current.formated_folio
      FolioCounter.next_folio if invoice.save
    end
  end
end
