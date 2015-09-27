class BillingAdjustment < ActiveRecord::Base
  belongs_to :payment
end
