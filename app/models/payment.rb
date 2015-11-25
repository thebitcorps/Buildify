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
  STATUS = [DUE_STATUS,PARTIALLY_DUE_STATUS,PAID_STATUS,'all_construction']

  # after_save :change_status_from_remaining!
  def self.all_construction(construction_id=nil)
    if construction_id
      where construction_id: construction_id
    else
      all
    end
  end

  def self.paid(construction_id=nil)
    if construction_id
      where status:  PAID_STATUS,construction_id: construction_id
    else
      where status:  PAID_STATUS
    end
  end

  def self.partially(construction_id=nil)

    if construction_id
      where status:  PARTIALLY_DUE_STATUS,construction_id: construction_id
    else
      where status:  PARTIALLY_DUE_STATUS
    end
  end

  def self.due(construction_id=nil)
    if construction_id
      where status:  DUE_STATUS,construction_id: construction_id
    else
      where status:  DUE_STATUS
    end
  end

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
