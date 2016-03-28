class PurchaseOrder < ActiveRecord::Base
  has_many :item_materials
  belongs_to :invoice
  belongs_to :requisition
  has_one :provider, through: :invoice
  has_one :construction, through: :requisition
  paginates_per 10
  # what does this mean?
        # Answer: In a previous schema there only can be a payment if an invoice exists related to a PO, after some talking with Llamas Pops later it was decided that payments can exist without an invoice in an office entity. But for now for PO the logic persists since it really can't be a payment for a PO if there isn't an invoice.
  has_one :payment, through: :invoice
  accepts_nested_attributes_for :item_materials, reject_if: :all_blank, allow_destroy: true
  ##################  Callbacks   ##################
  after_create :change_item_material_pending
  before_create :set_folio
  before_save :humanize_receiver
  after_create :check_requisition_items

  ##################     ##################
  COMPLETE_STATUS = 'complete'
  UNCOMPLETED_STATUS = 'pending'
  ##################  Scopes   ##################
  scope :sent, -> {where(status: COMPLETE_STATUS ).order(created_at: :desc)}
  scope :not_sent, -> {where( status: UNCOMPLETED_STATUS).order(created_at: :desc)}

  ##################  Methods   ##################
  def humanize_receiver
    self.delivery_receiver = delivery_receiver.humanize
  end

  def self.plural(count)
    count == 1 ? 'orden de compra' : 'ordenes de compra'
  end

  def formated_folio
    construction.id.to_s + construction.title[0..2].upcase + requisition.folio.to_s + folio.to_s.rjust(4, '0') + "-" + created_at.year.to_s
  end

  def check_requisition_items
    items_with_purchase = 0
    self.requisition.item_materials.each do |item_material|
      # count item materials that has assing to a purchase order
      if item_material.status != ItemMaterial::PENDING_STATUS
        items_with_purchase += 1
      end
    end

    if items_with_purchase == 0
      self.requisition.status = Requisition::PENDING_STATUS
    elsif items_with_purchase == self.requisition.item_materials.count
      self.requisition.status = Requisition::COMPLETE_STATUS
    else
      self.requisition.status = Requisition::PARTIALLY_STATUS
    end


    self.requisition.save
  end

  def completed?
    status == COMPLETE_STATUS
  end


  # change this to helper
  def get_color
    completed? ? 'info' : 'warning'
  end

  def change_item_material_pending
    ApplicationHelper::change_item_material_status self,ItemMaterial::AUTHORIZED_STATUS
  end

  def set_folio
    self.folio = self.construction.purchase_orders.count + 1
  end

end
