class Construction < ActiveRecord::Base
  belongs_to :resident, class_name: 'User', foreign_key: :user_id
  has_many :requisitions
  has_many :purchase_orders, through: :requisitions
  has_many :invoices, through: :purchase_orders
  has_many :invoice_receipts, through: :invoices
  has_many :payments
  has_many :invoiced_payments, through: :invoices, source: :payment
  paginates_per 10


  def self.search(search)
    return all if search.nil?
    unless search.empty?
      where('LOWER(title) LIKE ?',"%#{search}%")
    else
      all
    end
  end

end
