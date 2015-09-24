class PurchaseOrder < ActiveRecord::Base
  has_many :item_materials
  belongs_to :invoice
  belongs_to :requisition
  has_one :provider, through: :invoice
  has_one :construction, through: :requisition
  # what does this mean?
  has_one :apyment, through: :invoice
  has_one :invoice_receipt, through: :invoice
  accepts_nested_attributes_for :item_materials, reject_if: :all_blank, allow_destroy: true

  after_create :change_item_material_pending

  def change_item_material_pending
    ApplicationHelper::change_item_material_status self,ItemMaterial::AUTHORIZED_STATUS
  end

end
