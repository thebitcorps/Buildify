class FolioCounter < ActiveRecord::Base
  def self.get_current
    last || create!
  end

  def self.next_folio
    l = last
    l.year == Date.today::year ? l.update_attributes(count: l.count.succ) : FolioCounter.create(year: Date.today::year)
  end

  def formated_folio
    [count, year].join("-")
  end
end
