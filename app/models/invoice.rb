class Invoice < ActiveRecord::Base
  has_one :purchase_order
  has_one :requisition, through: :purchase_order
  has_one :construction, through: :requisition
  belongs_to :payment
  belongs_to :provider
  include PublicActivity::Common
  #status when the invoice is create in db
  WAITING_STATUS = 'waiting'
  #status when user finally capture the invoice
  ADDED_STATUS = 'added'
  #when the invice is partially paid
  PARTIALLY_STATUS = 'partially'
  #when the invoice is liquid
  PAID_STATUS = 'paid'

  after_update :set_purchase_order_sent
  after_update :notify_admins

  # validates :folio,:amount,:invoice_date,presence: true
  # validates :amount, numericality: true
  #we create the invoice always so we manage the existance of the invoice if the folio is nil
  #then the invoice have no been edited
  def waiting?
    self.status == WAITING_STATUS
  end

  def set_receipt_folio
    self.receipt_folio = purchase_order.folio.to_s + construction.title[0..2].upcase + id.to_s.rjust(4, '0')
    self.save
  end

  def set_purchase_order_sent
    purchase_order.status = PurchaseOrder::COMPLETE_STATUS
    purchase_order.save
  end

  def notify_admins
    # Uncomment until the we generate the invoice aparte from the purchase order
    # and change this to create callback
    # activity = create_activity(:update,owner: provider)
    # Notification.notify_admins activity
  end


end
