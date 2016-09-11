class Requisition < ActiveRecord::Base
  include AASM
  include PublicActivity::Common

  paginates_per 10

  COMPLETE_STATUS = 'complete'
  PENDING_STATUS = 'pending'
  SENT_STATUS = 'sent'
  PARTIALLY_STATUS = 'partially'

  ############# State machine ################
  aasm :column => 'status'
  aasm :whiny_transitions => false
  aasm do
    state :pending, initial: true
    state :sent
    state :partially
    state :complete

    event :sent ,after: :notify_requisition_sent do
      transitions :from => :pending, :to => :sent
    end

    event :partially_complete do
      transitions :from => :sent, :to => :partially
    end

    event :complete do
      transitions :from => [:sent, :partially], :to => :complete
    end
  end
  ##################  Active model   ##################
  belongs_to :construction
  belongs_to :creator, class_name: 'User', foreign_key: :user_id
  has_many :purchase_orders, dependent: :destroy
  has_many :item_materials, dependent: :destroy
  accepts_nested_attributes_for :item_materials, reject_if: :all_blank, allow_destroy: true
  has_many :invoices, through: :purchase_orders
  delegate :title, to: :construction, prefix: true
  ##################  VALIDATIONS   ##################
  validates :requisition_date, presence: true
  ##################  Callbacks   ##################
  after_create :change_item_material_pending
  before_create :next_folio
  before_create :set_formated_folio

  ##################  Scopes   ##################
  default_scope {order(created_at: :desc)}
  scope :from_construction, -> (construction_id=nil) {where(construction_id: construction_id)}

  ##################  Methods   ##################

  # which is better?
  # los auto incrementos de las DB guardan el último número en una tabla, a lo mejor podermos hacer lo mismo para tantos folios
  def self.next_folio(construction_id)
    last_requisition = where(construction_id: construction_id).first
    if last_requisition
      last_requisition.folio + 1
    else
      1
    end
  end

  def next_folio
    self.folio = Requisition.next_folio self.construction_id
  end

  def empty?
    item_materials.empty?
  end


  def set_formated_folio
    self.formated_folio = construction.id.to_s + construction.title[0..2].upcase + folio.to_s.rjust(4, '0') + "-" + requisition_date.year.to_s
  end

  def self.plural(count)
    count == 1 ? 'requisicion' : 'requisiciones'
  end

  def change_item_material_pending
    ApplicationHelper::change_item_material_status self, ItemMaterial::PENDING_STATUS
  end

  def item_materials_status_count
    status_count = {count: item_materials.count,authorized: 0,delivered: 0,missed: 0,pending: 0,partially: 0}
    item_materials.each do |item_material|
      status_count[item_material.status.to_sym] += 1
    end
    status_count
  end

  # change this to helper
  def status_color
    if complete?
      'success'
    elsif pending?
      'default'
    elsif partially?
      'warning'
    elsif sent?
      'danger'
    end
  end
  private
  def notify_requisition_sent
    public_activity = create_activity(:create, owner: creator)
    Notification.notify_admins(public_activity)
  end

end
