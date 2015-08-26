class Construction < ActiveRecord::Base
  belongs_to :resident, class_name: 'User', foreign_key: :user_id
  has_many :requisitions
  has_many :purchase_orders, through: :requisitions
  has_many :invoices, through: :purchase_orders
  has_many :invoice_receipts, through: :invoices
  has_many :payments
  has_many :invoiced_payments, through: :invoices, source: :payment
  paginates_per 10

  validates :title, presence: true
  validate :validate_dates_logic_relation
  validates :contract_amount, presence: true

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
      where("title LIKE ?", "%#{query}%")
    end
  end

end
