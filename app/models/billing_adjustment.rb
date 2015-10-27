class BillingAdjustment < ActiveRecord::Base
  belongs_to :payment
  after_save :payment_status_and_add_amount
  before_destroy  :subtract_amount_for_payment


  PAYMENT_TYPES = %w[Transferencia Cheque]
  validates :payment_type, presence: true
  validate :amount_not_greater_than_limit

  def subtract_amount_for_payment
    self.payment.paid_amount -= self.amount
    self.payment.change_status_from_remaining!
    self.payment.save
  end

  def payment_status_and_add_amount
    self.payment.paid_amount += self.amount
    self.payment.change_status_from_remaining!
    self.payment.save
  end

  def amount_not_greater_than_limit
    if amount.nil?
      errors.add :amount,"No puede estar vacio"
      return
    end
    helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new

    if payment.amount < payment.paid_amount + amount
      errors.add :amount,"Con esta cantidad sobrepasaria el limite de la deuda actual de esta factura que es #{helper.number_to_currency payment.amount}"
    end
  end
end
