class MesureUnit < ActiveRecord::Base
  has_many :permitted_mesure_units

  validates :unit,:abbreviation, presence: true
end
