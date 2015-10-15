class Construction < ActiveRecord::Base
  belongs_to :manager,class_name: 'User', foreign_key: :user_id
  has_many :requisitions
  has_many :purchase_orders, through: :requisitions
  has_many :invoices, through: :purchase_orders
  has_many :invoice_receipts, through: :invoices
  has_many :payments
  has_many :estimates
  has_many :invoiced_payments, through: :invoices, source: :payment
  has_many :construction_users, dependent: :destroy
  has_many :residents, class_name: 'User',through: :construction_users,foreign_key: :user_id,source: :user
  accepts_nested_attributes_for :construction_users, reject_if: :all_blank, allow_destroy: true
  paginates_per 10

  # note database default is 'running' not associated with this constant of change change db default also
  RUNNING_STATUS = 'running'
  STOPPED_STATUS = 'stopped'
  FINISH_STATUS = 'finished'


  validates :title,:address,:contract_amount,:manager, presence: true
  validate :validate_dates_logic_relation


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
