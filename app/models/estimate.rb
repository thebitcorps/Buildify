class Estimate < ActiveRecord::Base
  belongs_to :construction
  validates :amount,:payment_date, presence: true
  validates :amount, numericality: {message: 'Monto debe ser numerico'}
end
