class PurchaseOrder < ActiveRecord::Base
  has_many :item_materials,dependent: :destroy
  belongs_to :invoice
  belongs_to :requisition
  has_one :provider, through: :invoice
  has_one :construction, through: :requisition
  # what does this mean?
  has_one :apyment, through: :invoice
  has_one :invoice_receipt, through: :invoice
  accepts_nested_attributes_for :item_materials, reject_if: :all_blank, allow_destroy: true

  after_create :change_item_material_pending
  before_create :set_folio

  after_create :check_requisition_items

  def check_requisition_items
    self.requisition.item_materials.each do |item_material|
      if item_material.status == ItemMaterial::PENDING_STATUS
        self.requisition.locked = false
        self.requisition.save
        return
      end
    end
    self.requisition.locked = true
    self.requisition.save
  end

  def change_item_material_pending
    ApplicationHelper::change_item_material_status self,ItemMaterial::AUTHORIZED_STATUS
  end

  def set_folio
    self.folio = self.construction.purchase_orders.count + 1
  end

end
