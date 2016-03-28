class ItemMaterial < ActiveRecord::Base
  belongs_to :requisition
  belongs_to :purchase_order
  belongs_to :material
  has_one :invoice, through: :purchase_order
  has_one :construction, through: :requisition
  has_one :provider, through: :purchase_order
  has_one :invoice_receipt, through: :invoice
  has_one :payment, through: :invoice

  validates :requested, numericality: true

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

  def partially?
    status == PARTIALLY_DELIVERED_STATUS
  end
  def deliver?
    status == DELIVERED_STATUS
  end
  def missed?
    status == MISSED_STATUS
  end
  def authorize?
    status == AUTHORIZED_STATUS
  end

  def full_item_request
    "#{requested} #{measure_unit}"
  end

  def get_color

    if status == PARTIALLY_DELIVERED_STATUS
      'warning'
    elsif status == DELIVERED_STATUS
      'success'
    elsif status == MISSED_STATUS
      'danger'
    else
      'dafault'
    end
  end


end
