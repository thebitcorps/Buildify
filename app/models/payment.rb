class Payment < ActiveRecord::Base
  belongs_to :purchase_order
  belongs_to :invoice
  belongs_to :construction
  # has_one :invoice, dependent: :nullify
  # has_one :purchase_order, through: :invoice
  has_one :requisition, through: :purchase_order
  has_one :invoiced_construction, through: :requisition, source: :construction
  has_many :billing_adjustments

  paginates_per 10
  DUE_STATUS = 'due'
  PARTIALLY_DUE_STATUS = 'partially'
  PAID_STATUS = 'paid'
  PETTY_CASH_STATUS = 'petty_cash'
  STATUS = [DUE_STATUS,PARTIALLY_DUE_STATUS,'paid.no_petty_cash','all_construction',PETTY_CASH_STATUS]

  # after_save :change_status_from_remaining!

  # not using includes because we only using invoice_id for the moment
  # if will use invoice or purchase order from the payments use includes
  scope :from_purchase_order, ->(purchase_order_id){
    where purchase_order_id: purchase_order_id
  }

  # not using includes because we only using invoice_id for the moment
  # if will use invoice or purchase order from the payments use includes
  scope :not_from_purchase_order, ->(purchase_order_id){
    where.not purchase_order_id: purchase_order_id
  }

  scope :active,-> (){
    ids = Construction.running.pluck(:id)
    includes(:invoice,:purchase_order).where construction_id: ids
  }

  scope :all_construction, ->(construction_id=nil){
    if construction_id
      includes(:invoice,:purchase_order).where construction_id: construction_id
    else
      active
    end
  }

  scope  :paid, ->(construction_id=nil){
    if construction_id
      all_construction(construction_id).where status:  :paid
    else
      includes(:invoice,:purchase_order).where status:  :paid
    end
  }

  scope :partially,->(construction_id=nil){
    if construction_id
      all_construction(construction_id).where status:  :partially
    else
      active.where status:  :partially
    end
  }

  scope :due,->(construction_id=nil){
    if construction_id
      all_construction(construction_id).where status:  :due
    else
      active.where status:  :due
    end
  }

  scope :petty_cash, ->(construction_id=nil){
    if construction_id
      includes(:invoice,:purchase_order).where "construction_id=? AND id NOT IN (SELECT payment_id FROM invoices)", construction_id
    else
      includes(:invoice,:purchase_order).where "id NOT IN (SELECT payment_id FROM invoices)"
    end
  }
  scope :no_petty_cash, ->(construction_id=nil){
    if construction_id
      includes(:invoice,:purchase_order).where "construction_id=? AND id IN (SELECT payment_id FROM invoices)", construction_id
    else
      includes(:invoice,:purchase_order).where "id IN (SELECT payment_id FROM invoices)"
    end
  }

  def get_color
    if status == PAID_STATUS
      'success'
    elsif status == PARTIALLY_DUE_STATUS
      'warning'
    else
      'danger'
    end
  end


  def remaining
    amount - paid_amount.to_f
  end


  def change_status_from_remaining!
    if paid_amount == amount
      status = PAID_STATUS
    elsif paid_amount > 0
      status = PARTIALLY_DUE_STATUS
    else
      status = DUE_STATUS
    end
    self.update_attribute 'status',status
  end


end
