class AgainstReceipt < ActiveRecord::Base
  belongs_to :purchase_order
  belongs_to :invoice



end
