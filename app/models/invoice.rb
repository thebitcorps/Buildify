class Invoice < ActiveRecord::Base
  has_one :purchase_order
  has_one :requisition, through: :purchase_order
  has_one :construction, through: :requisition
  belongs_to :payment
  belongs_to :invoice_receipt
  belongs_to :provider
  #status when the invoice is create in db
  WAITING_STATUS = 'waiting'
  #status when user finally capture the invoice
  ADDED_STATUS = 'added'
  #when the invice is partially paid
  PARTIALLY_STATUS = 'partially'
  #when the invoice is liquid
  PAID_STATUS = 'paid'

  after_update :set_purchase_order_sent
  # validates :folio,:amount,:invoice_date,presence: true
  # validates :amount, numericality: true
  #we create the invoice always so we manage the existance of the invoice if the folio is nil
  #then the invoice have no been edited
  def waiting?
    self.status == WAITING_STATUS
  end


  def set_purchase_order_sent
    purchase_order.sended = true
    purchase_order.save
  end


end
