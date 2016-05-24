class ItemMaterial < ActiveRecord::Base
  include AASM
  belongs_to :requisition
  belongs_to :purchase_order
  belongs_to :material
  has_one :invoice, through: :purchase_order
  has_one :construction, through: :requisition
  has_one :provider, through: :purchase_order
  has_one :invoice_receipt, through: :invoice
  has_one :payment, through: :invoice

  validates :requested, numericality: true
  scope :pendings, -> {where(status: 'pending')}
  ########## STATE MACHINE ##########
  aasm :column => 'status'
  aasm :whiny_transitions => false
  aasm do
    state :pending ,initial: true
    state :partially, :delivered, :authorized, :missed
    event :authorize do
      transitions :from => :pending, :to => :authorized
    end

    event :miss do
      transitions :from => [:partially, :delivered, :authorized], :to => :missed
    end

    event :deliver do
      transitions :from => [:partially, :missed, :authorized], :to => :delivered
    end

    event :partially do
      transitions :from => [:delivered, :missed, :authorized], :to => :partially
    end

  end

  #when the itemMaterial was't fully deliver
  PARTIALLY_DELIVERED_STATUS = 'partially'
  #when the itemMaterial was delivered complete to construction
  DELIVERED_STATUS = 'delivered'
  # when the purchse order was for that item is already created
  AUTHORIZED_STATUS = 'authorized'
  #when the itemMaterial was't deliver to construction
  MISSED_STATUS = 'missed'
  #the item mateterial is waiting for a purchase order to be generate
  PENDING_STATUS = 'pending'

  STATUS = [DELIVERED_STATUS, PENDING_STATUS, PARTIALLY_DELIVERED_STATUS, AUTHORIZED_STATUS]


  def full_item_request
    "#{requested} #{measure_unit}"
  end

  def get_color
    if partially?
      'warning'
    elsif delivered?
      'success'
    elsif missed?
      'danger'
    else
      'dafault'
    end
  end


end
