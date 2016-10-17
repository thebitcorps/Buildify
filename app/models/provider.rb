class Provider < ActiveRecord::Base
  has_many :invoices
  has_many :purchase_orders
  has_many :requisitions, through: :purchase_orders
  has_many :constructions, through: :requisitions
  paginates_per 15
  # validations for provider
  validates :name, presence: true
  before_update :humanize_attr
  scope :all_alphabetical, -> { all.order("LOWER(name)") }

  # validates :zipcode, numericality: {message: 'Código postal debe ser numérico'}, length: {is: 5, message: 'Código postal debe contener 5 digitos'}
  # validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'E-mail inválido'
  # validates :telephone, numericality: {message: 'Télefono debe ser numérico'}, length: { in: 7..10, message: 'Teléfono inválido' }

  before_save :humanize_attr

  def humanize_attr
    self.name = name.titleize
    self.nickname = nickname.titleize
    self.neighborhood = neighborhood.humanize
    self.city = city.humanize
    self.street = street.humanize
  end

  def natural_name
    nickname.blank?  ? name : nickname
  end

  def compound_name
    nick = nickname.blank?  ? "" : "(#{nickname})"
    "#{nick} #{name}"
  end

  def payments
    ids = invoices.pluck(:id)
    Payment.where(invoice_id: ids)
  end

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
      q = "%#{query}%"
      where('name ilike ? OR nickname ilike ?', q, q)
    end
  end

  def address
    "#{street} ##{number},#{neighborhood},#{city} C.P #{zipcode}"
  end
end
