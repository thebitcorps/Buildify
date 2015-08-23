class Requisition < ActiveRecord::Base
  belongs_to :construction
  has_many :purchase_orders
  has_many :item_materials
  has_many :invoices, through: :purchase_orders

  def self.next_folio(construction_id)
    where(construction_id: construction_id).count + 1
  end

end
