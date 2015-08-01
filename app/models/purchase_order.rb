class PurchaseOrder < ActiveRecord::Base
  has_many :item_materials
  belongs_to :invoice

  def requisition
    item_materials.first.requisition if !item_materials.blank?
  end

  def construction
    requisition.construction
  end
end
