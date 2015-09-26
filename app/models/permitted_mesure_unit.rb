class PermittedMesureUnit < ActiveRecord::Base
  belongs_to :material
  belongs_to :mesure_unit
end
