class ItemMaterial < ActiveRecord::Base
  belongs_to :requisition
  belongs_to :purchase_order
end
