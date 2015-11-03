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
  before_create :set_folio

  after_create :check_requisition_items


  scope :sent, -> {where sended: true}
  scope :not_sent, -> {where sended: false}

  def self.plural(count)
    count == 1 ? 'orden de compra' : 'ordenes de compra'
  end

  def check_requisition_items
    items_with_purchase = 0
    self.requisition.item_materials.each do |item_material|
      if item_material.status == ItemMaterial::AUTHORIZED_STATUS
        items_with_purchase += 1
      end
      if items_with_purchase == 0
        self.requisition.status = Requisition::PENDING_STATUS
      elsif items_with_purchase == self.requisition.item_materials.count
        self.requisition.status = Requisition::LOCKED_STATUS
      else
        self.requisition.status = Requisition::PARTIALLY_STATUS
      end
    end

    self.requisition.save
  end

  # change this to helper
  def get_color
    sended ? 'info' : 'warning'
  end

  def change_item_material_pending
    ApplicationHelper::change_item_material_status self,ItemMaterial::AUTHORIZED_STATUS
  end

  def set_folio
    self.folio = self.construction.purchase_orders.count + 1
  end

end
