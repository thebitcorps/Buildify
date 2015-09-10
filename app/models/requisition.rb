class Requisition < ActiveRecord::Base
  belongs_to :construction
  has_many :purchase_orders
  has_many :item_materials, dependent: :destroy
  accepts_nested_attributes_for :item_materials,reject_if: :all_blank, allow_destroy: true
  has_many :invoices, through: :purchase_orders

  validates :requisition_date ,presence: true

  # def self.next_folio(construction_id)
  #   where(construction_id: construction_id).count + 1
  # end

  # which is better?
  def self.next_folio(construction_id)
    last_requisition = where(construction_id: construction_id).last
    if last_requisition
      last_requisition.folio + 1
    else
      0
    end
  end



end
