class Material < ActiveRecord::Base
  has_many :item_materials

  scope :all_alphabetical, -> { all.order("LOWER(name)") }
end
