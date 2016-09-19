class Construction < ActiveRecord::Base
  belongs_to :manager, class_name: 'User', foreign_key: :user_id
  has_many :requisitions
  has_many :purchase_orders, through: :requisitions
  has_many :invoices, through: :purchase_orders
  has_many :invoice_receipts, through: :invoices
  has_many :payments
  has_many :estimates
  has_many :extensions
  has_many :petty_cashes,dependent: :destroy
  has_many :invoiced_payments, through: :invoices, source: :payment
  has_many :construction_users, dependent: :destroy
  has_many :residents, class_name: 'User', through: :construction_users, foreign_key: :user_id, source: :user
  accepts_nested_attributes_for :construction_users, reject_if: :all_blank, allow_destroy: true
  paginates_per 10

  # note database default is 'running' not associated with this constant of change change db default also
  # when construction is in progress
  # when the construction is successfully finished
  STATUS_OPTIONS = {'En proceso' => :running,'Detenida ' => :stopped,'Termindada' => :finished}
  STATUS = [:running,:stopped,:finished]
  ROLES = %w[velador ayudante]

  after_create :create_initial_petty_cash
  ##################  VALIDATIONS   ##################
  # validate :validate_field
  validate :validate_fields
  validate :validate_dates_logic_relation
  validate :validate_contract_amount

  def create_initial_petty_cash
    PettyCash.create construction_id: id,amount: PettyCash::DEFAULT_AMOUNT
  end

  def validate_contract_amount
    # skip validations if is and office object
    return if type == 'Office'
    unless (true if Float(contract_amount) rescue false)
      errors.add(:contract_amount,'no es numerico.')
    end
  end

  def validate_fields
    # skip validations if is and office object
    return if type == 'Office'
    [:title,:address].each do |field|
      if self[field].empty?
        errors.add(field,'no puede estar vacio.')
      end
    end
    # check for bigdecimal and assosiation for nil? value
    [:contract_amount,:manager].each do |field|
      if instance_eval "self.#{field}.nil?"
        errors.add(field,'no puede estar vacio.')
      end
    end
  end


  def validate_dates_logic_relation
    if finish_date.nil?
      errors.add(:finish_date,"Can't be blank")
      return

    end
    if start_date.nil?
      errors.add(:start_date,"Can't be blank")
      return
    end
    errors.add(:finish_date, 'Finish date must be greater than start date') if finish_date < start_date
  end
  ##################  SCOPES   ##################
  scope :running, ->{(where status: :running).order(created_at: :asc)}
  scope :stopped, ->{(where status: :stopped).order(created_at: :asc)}
  scope :finished, ->{(where status: :finished).order(created_at: :asc)}
  scope :all_constructions,-> {(where type: nil).order(created_at: :asc)}

  ##################  METHODS   ##################
  def active_petty_cash
    petty_cashes.last
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

  def extensions_amount
    budget  = 0
    self.extensions.each do |extension|
      budget += extension.amount
    end
    budget
  end

  def total_budget
    extensions_amount + contract_amount
  end


  def invoiced_purchases_orders
    # purchase_orders.select { |po| !po.invoice.waiting?}
    purchase_orders
  end

  def uninvoiced_purchases_orders
    purchase_orders
    # purchase_orders.select { |po| po.invoice.waiting?}
  end

  def office?
    type == 'Office'
  end

  def running?
    status == 'running'
  end

  def stopped?
    status == 'stopped'
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
      all.order(title: :asc)
    else
      where("title ilike ?", "%#{query}%").order(title: :asc)
    end
  end


end
