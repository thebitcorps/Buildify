class Invoice < ActiveRecord::Base
  has_one :purchase_order
  has_one :requisition, through: :purchase_order
  has_one :construction, through: :requisition
  belongs_to :payment
  has_one :provider, through: :purchase_order
  include PublicActivity::Common
  #status when the invoice is create in db
  WAITING_STATUS = 'waiting'
  #status when user finally capture the invoice
  ADDED_STATUS = 'added'
  #when the invice is partially paid
  PARTIALLY_STATUS = 'partially'
  #when the invoice is liquid
  PAID_STATUS = 'paid'

  before_update :validate_fields
  before_update :set_purchase_order_sent
  after_update :notify_admins
  before_update :set_payment
  before_update :set_invoice_folio


  # validates :folio,:amount,:invoice_date,presence: true
  # validates :amount, numericality: true
  #we create the invoice always so we manage the existance of the invoice if the folio is nil
  #then the invoice have no been edited
  def waiting?
    self.status == WAITING_STATUS
  end

  def set_consecutiive_folio
    last = Invoice.order('created_at DESC').limit(2).last
    if Invoice.all.count > 1
      if last.created_at.year == Date.today.year
        self.consecutive_folio = last.consecutive_folio +  1
        return
      end
    end
    self.consecutive_folio = 1
  end

  def set_invoice_folio
    set_consecutiive_folio
    self.folio = self.consecutive_folio.to_s + '-' + Date.today.year.to_s
  end

  def set_payment
    # after payment creation editing not working
    payment = self.payment || Payment.create(amount: self.amount, payment_date: self.invoice_date, construction: self.construction)
    self.payment = payment
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
