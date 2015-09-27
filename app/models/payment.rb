class Payment < ActiveRecord::Base
  belongs_to :construction
  has_one :invoice
  has_one :purchase_order, through: :invoice
  has_one :requisition, through: :purchase_order
  has_one :invoiced_construction, through: :requisition, source: :construction
  has_many :billing_adjustments
end
