class Invoice < ActiveRecord::Base
  has_one :purchase_order
  has_many :purchase_orders, through: :payments
  has_many :payments
  has_one :requisition, through: :purchase_order
  belongs_to :construction
  belongs_to :payment
  belongs_to :provider
  include PublicActivity::Common
  #status when the invoice is create in db

  paginates_per 25
  WAITING_STATUS = 'waiting'
  #status when user finally capture the invoice
  ADDED_STATUS = 'added'
  #when the invice is partially paid
  PARTIALLY_STATUS = 'partially'
  #when the invoice is liquid
  PAID_STATUS = 'paid'

  # before_update :validate_fields
  # before_update :set_purchase_order_sent
  # after_update :notify_admins
  before_create :set_invoice_folio
  after_create :next_folio
  # before_create :set_payment

  # validates :folio,:amount,:invoice_date,presence: true
  # validates :amount, numericality: true
  #we create the invoice always so we manage the existance of the invoice if the folio is nil
  #then the invoice have no been edited
  def waiting?
    self.status == WAITING_STATUS
  end

  def set_invoice_folio
    self.folio = FolioCounter.get_current.formated_folio
  end

  def next_folio
    FolioCounter.next_folio
  end

  def set_payment
    # after payment creation editing not working
    payment = Payment.create(amount: self.amount, payment_date: self.invoice_date, construction_id: self.construction_id)
    self.payment_id = payment.id
  end

  def set_purchase_order_sent
    purchase_order.complete!
  end

  def notify_admins
    activity = create_activity(:update,owner: provider)
    Notification.notify_admins activity
  end

  def validate_fields
    errors.add(:purchase_order, "Orden de compra no esta firmada") unless purchase_order.stamped? or purchase_order.complete?
    errors.add(:amount, "No puede estar vacio") if amount.nil?
    errors.add(:provider_folio, "No puede estar vacio") if receipt_folio.nil?
    errors.add(:invoice_date, "No puede estar vacio") if invoice_date.nil?

  end


end
