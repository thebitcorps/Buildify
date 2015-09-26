class Provider < ActiveRecord::Base
  has_many :invoices
  has_many :purchase_orders, through: :invoices
  has_many :requisitions, through: :purchase_orders
  has_many :constructions, through: :requisitions
  has_many :payments, through: :invoices

  # validations for provider
  validates :name, :email, :telephone, :address, presence: true
  scope :all_alphabetical, -> { all.order("LOWER(name)") }

  def self.search(query)
    return all if query.nil?
    if query.empty?
      all
    else
      where('name ilike ?', "%#{query}%")
    end
  end
end
