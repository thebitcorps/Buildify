class MeasureUnit < ActiveRecord::Base
  has_many :permitted_measure_units

  validates :unit,:abbreviation, presence: true
end
