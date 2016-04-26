class Requisition < ActiveRecord::Base

  paginates_per 10

  COMPLETE_STATUS = 'complete'
  PENDING_STATUS = 'pending'
  SENT_STATUS = 'sent'
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
  # scope :partially, ->(construction_id=nil) { where status: PARTIALLY_STATUS,construction_id: construction_id}
  def self.partially(construction_id=nil)
    requisitions_with_construction :partially,construction_id
  end
  def self.pending(construction_id=nil)
    requisitions_with_construction :pending,construction_id
  end
  def self.complete(construction_id=nil)
    requisitions_with_construction :complete,construction_id
  end

  def self.sent(construction_id=nil)
    requisitions_with_construction :sent,construction_id
  end


  def self.all_with_conctruction(construction_id=nil)
    query = all
    unless construction_id.nil?
      query = query.where construction_id: construction_id
    end
    query.order(created_at: :desc)
  end

  def self.requisitions_with_construction(status,construction_id)
    query = where status: status
    unless construction_id.nil?
      query = query.where construction_id: construction_id
    end
    query.order(created_at: :desc)
  end

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

  def sent?
    status == SENT_STATUS
  end

  def pending?
    status == PENDING_STATUS
  end

  def partially?
    status == PARTIALLY_STATUS
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

end
