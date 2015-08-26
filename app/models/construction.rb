class Construction < ActiveRecord::Base
  belongs_to :resident, class_name: 'User', foreign_key: :user_id
  has_many :requisitions
  has_many :purchase_orders, through: :requisitions
  has_many :invoices, through: :purchase_orders
  has_many :invoice_receipts, through: :invoices
  has_many :payments
  has_many :invoiced_payments, through: :invoices, source: :payment
  paginates_per 10

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
