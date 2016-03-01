class Extension < ActiveRecord::Base
  belongs_to :construction
  scope :where_construction, ->(construction_id){where(construction_id: construction_id).order(date: :asc)}
  validates :amount,:date,presence: true

end
