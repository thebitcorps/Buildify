class PermittedMeasureUnit < ActiveRecord::Base
  belongs_to :material
  belongs_to :measure_unit
end
