class Payment < ActiveRecord::Base
  belongs_to :construction
  has_one :invoice
  has_one :purchase_order, through: :invoice
  has_one :requisition, through: :purchase_order
  has_one :invoiced_construction, through: :requisition, source: :construction
  has_many :billing_adjustments



  DUE_STATUS = 'due'
  PARTIALLY_DUE_STATUS = 'partially'
  PAID_STATUS = 'paid'

  scope :due, -> {where status:  DUE_STATUS}
  scope :partially, -> {where status:  PARTIALLY_DUE_STATUS}
  scope :paid, -> {where status:  PAID_STATUS}

  # after_save :change_status_from_remaining!



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
