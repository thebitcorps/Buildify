class MeasureUnit < ActiveRecord::Base
  has_many :permitted_measure_units

  validates :unit,:abbreviation, presence: true
  before_save :humanize_attr

  def humanize_attr
    self.unit = unit.humanize
  end
end
