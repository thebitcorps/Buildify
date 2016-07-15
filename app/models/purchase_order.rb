require 'digest/sha1'
class PurchaseOrder < ActiveRecord::Base
  include AASM
  include PublicActivity::Common
  # id, folio, delivery_place, delivery_address, delivery_receiver, status
  # requisition_id, invoice_id, created_at, updated_at, stamp, authorizer_id, stamp_date
  attr_accessor :stamp_purchase_order
  has_many :item_materials
  belongs_to :invoice
  belongs_to :requisition
  belongs_to :authorizer, class_name: "User", foreign_key: :authorizer_id
  has_one :provider, through: :invoice
  has_one :construction, through: :requisition
  paginates_per 10
  # what does this mean?
        # Answer: In a previous schema there only can be a payment if an invoice exists related to a PO, after some talking with Llamas Pops later it was decided that payments can exist without an invoice in an office entity. But for now for PO the logic persists since it really can't be a payment for a PO if there isn't an invoice.
  has_one :payment, through: :invoice
  accepts_nested_attributes_for :item_materials, reject_if: :all_blank, allow_destroy: true
  ##################  State machine   ##################
  aasm :column => 'status'
  aasm :whiny_transitions => false
  aasm do
    state :pending, initial: true, before_enter: :set_formated_folio
    state :complete
    state :stamped
    # should be authorize to be stamp, this could change
    event :complete do
      transitions :from =>  :stamped, :to => :complete
    end

    event :stampp, after: [:stamp_it, :notify_purchase_order_creation] do
      transitions :from => :pending, :to => :stamped
    end
  end
  ##################  Callbacks   ##################
  after_create :authorize_item_materials
  before_create :set_folio
  before_create :set_formated_folio
  before_save :humanize_receiver
  after_create :update_requisition_state

  #### Validations ####
  validates :delivery_receiver, :status, :requisition_id, presence: true
  ##################     ##################
  COMPLETE_STATUS = 'complete'
  UNCOMPLETED_STATUS = 'pending'
  STAMPED_STATUS = 'stamped'
  ##################  Scopes   ##################
  default_scope {order(created_at: :desc)}
  scope :active, ->{
    joins(:construction).where(constructions: {status: :running})
  }

  ##################  Methods   ##################
  def humanize_receiver
    self.delivery_receiver = delivery_receiver.humanize
  end

  def self.plural(count)
    count == 1 ? 'orden de compra' : 'ordenes de compra'
  end

  def set_formated_folio
    self.formated_folio = construction.id.to_s + construction.title[0..2].upcase + requisition.folio.to_s + folio.to_s.rjust(4, '0') + "-" + created_at.year.to_s
  end

  def authorize_item_materials
    item_materials.collect { |item_material| item_material.authorize!}
  end

  def update_requisition_state
    items_with_purchase =0
    self.requisition.item_materials.each do |item|
      items_with_purchase += 1 if item.authorized?
    end

    if items_with_purchase == 0
      self.requisition.sent!
    elsif items_with_purchase == self.requisition.item_materials.count
      self.requisition.complete!
    else
      self.requisition.partially_complete!
    end
  end

  def completed?
    status == COMPLETE_STATUS
  end

  def is_stamped?
    stamp?
  end

  # change this to helper
  def get_color
    completed? ? 'info' : 'warning'
  end

  def set_folio
    self.folio = self.construction.purchase_orders.count + 1
  end

  def stamp_it(user)
    self.stamp = stamper(user.name)
    self.authorizer = user
    self.stamp_date = Date.today
    save
  end

  def verify_stamp(params_stamp)
    is_stamped? && params_stamp == stamp
  end

  def item_materials_status_count
    status_count = {count: item_materials.count,authorized: 0,delivered: 0,missed: 0,pending: 0,partially: 0}
    item_materials.each do |item_material|
      status_count[item_material.status.to_sym] += 1
    end
    status_count
  end

  private

  def notify_purchase_order_creation
    public_activity = create_activity(:create, owner: authorizer)
    Notification.notify_residents(public_activity,construction)
    Notification.notify_secretary(public_activity)
  end

  def stamper(authority_name)
    Digest::SHA1.base64digest([updated_at, authority_name, item_materials.size].join(", "))
  end
end
