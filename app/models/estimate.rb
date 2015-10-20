class Estimate < ActiveRecord::Base
  belongs_to :construction
  validates :amount,:payment_date, presence: true
end
