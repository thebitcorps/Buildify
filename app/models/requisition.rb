class Requisition < ActiveRecord::Base

  COMPLETE_STATUS = 'complete'
  PENDING_STATUS = 'pending'
  PARTIALLY_STATUS = 'partially'

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
  # def self.next_folio(construction_id)
  #   where(construction_id: construction_id).count + 1
  # end

  ##################  Scopes   ##################
  scope :partially, ->(construction_id=nil) {where status: PARTIALLY_STATUS,construction_id: construction_id}
  scope :pending, -> { where status: PENDING_STATUS }
  scope :complete, -> { where status: COMPLETE_STATUS }

  ##################  Methods   ##################
  # which is better?
  # los auto incrementos de las DB guardan el último número en una tabla, a lo mejor podermos hacer lo mismo para tantos folios
  def self.next_folio(construction_id)
    last_requisition = where(construction_id: construction_id).last
    if last_requisition
      last_requisition.folio + 1
    else
      1
    end
  end

  def formated_folio
    construction.id.to_s + construction.title[0..2].upcase + folio.to_s.rjust(4, '0') + "-" + requisition_date.year.to_s
  end

  def self.plural(count)
    count == 1 ? 'requisicion' : 'requisiciones'
  end

  def change_item_material_pending
    ApplicationHelper::change_item_material_status self, ItemMaterial::PENDING_STATUS
  end

  def complete?
    status == COMPLETE_STATUS
  end

  def pending?
    status == PENDING_STATUS
  end

  def partially?
    status == PARTIALLY_STATUS
  end
  # change this to helper
  def status_color
    if complete?
      'success'
    elsif pending?
      'danger'
    elsif partially?
      'warning'
    else
      'default'
    end
  end

end
