class Construction < ActiveRecord::Base
  belongs_to :manager, class_name: 'User', foreign_key: :user_id
  has_many :requisitions
  has_many :purchase_orders, through: :requisitions
  has_many :invoices, through: :purchase_orders
  has_many :invoice_receipts, through: :invoices
  has_many :payments
  has_many :estimates
  has_many :extensions
  has_many :invoiced_payments, through: :invoices, source: :payment
  has_many :construction_users, dependent: :destroy
  has_many :residents, class_name: 'User', through: :construction_users, foreign_key: :user_id, source: :user
  accepts_nested_attributes_for :construction_users, reject_if: :all_blank, allow_destroy: true
  paginates_per 10

  # note database default is 'running' not associated with this constant of change change db default also
  # when construction is in progress
  RUNNING_STATUS = 'running'
  STOPPED_STATUS = 'stopped'
  # when the construction is successfully finished
  FINISH_STATUS = 'finished'
  STATUS_OPTIONS = {'En proceso' => RUNNING_STATUS,'Detenida ' => STOPPED_STATUS,'Termindada' => FINISH_STATUS}
  STATUS = [RUNNING_STATUS,STOPPED_STATUS,FINISH_STATUS]
  validates :title,:address,:contract_amount,:manager, presence: true

  validate :validate_dates_logic_relation
  validates :contract_amount, numericality: true


  scope :running, ->{where status: RUNNING_STATUS}
  ROLES = %w[velador ayudante]

  def expenses
    payments.sum :amount
  end

  def paid
    payments.sum :paid_amount
  end

  def balance
    expenses - paid
  end

  def pending_requisitions(user = nil)
    if user.nil?
      requisitions.where status: Requisition::PENDING_STATUS
    else
      requisitions.where status: Requisition::PENDING_STATUS, user_id: user.id
    end
  end

  def partial_requisitions(user = nil)
    if user.nil?
      requisitions.where status: Requisition::PARTIALLY_STATUS
    else
      requisitions.where status: Requisition::PARTIALLY_STATUS, user_id: user.id
    end
  end

  def complete_requisitions(user = nil)
    if user.nil?
      requisitions.where status: Requisition::COMPLETE_STATUS
    else
      requisitions.where status: Requisition::COMPLETE_STATUS, user_id: user.id
    end
  end

  def invoiced_purchases_orders
    purchase_orders.select { |po| !po.invoice.waiting?}
  end

  def uninvoiced_purchases_orders
    purchase_orders.select { |po| po.invoice.waiting?}
  end


  def validate_dates_logic_relation
      errors.add(:finish_date, "Finish date must be greater than start date") if finish_date < start_date
  end

  def days_passed
    (DateTime.now.to_date - start_date).to_i
  end

  def available_days
    (finish_date - start_date).to_i
  end

  def self.search(query)
    return all if query.nil?
    if query.empty?
      all
    else
      where("title ilike ?", "%#{query}%")
    end
  end

end
