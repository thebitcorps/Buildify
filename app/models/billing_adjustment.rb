class BillingAdjustment < ActiveRecord::Base
  belongs_to :payments
end
