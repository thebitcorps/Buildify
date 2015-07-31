class PurchaseOrder < ActiveRecord::Base
	has_many :item_materials

	def requisition
		item_materials.first.requisition if !item_materials.blank?
	end
end
