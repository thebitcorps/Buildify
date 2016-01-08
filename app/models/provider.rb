class Provider < ActiveRecord::Base
  has_many :invoices
  has_many :purchase_orders, through: :invoices
  has_many :requisitions, through: :purchase_orders
  has_many :constructions, through: :requisitions
  has_many :payments, through: :invoices
  paginates_per 15
  # validations for provider
  validates :name, :number, :neighborhood, :city, :street, :zipcode, :email, :telephone, presence: true
  scope :all_alphabetical, -> { all.order("LOWER(name)") }

  def expenses
    payments.sum :amount
  end

  def paid
    payments.sum :paid_amount
  end

  def balance
    expenses - paid
  end

  def self.search(query)
    return all if query.nil?
    if query.empty?
      all
    else
      where('name ilike ?', "%#{query}%")
    end
  end

  def address
    "#{street} ##{number},#{neighborhood},#{city} C.P #{zipcode}"
  end
end
