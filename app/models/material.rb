class Material < ActiveRecord::Base
  has_many :item_materials
  paginates_per 10
  has_many :permitted_measure_units
  has_many :measure_units, through: :permitted_measure_units
  scope :all_alphabetical, -> { all.order("LOWER(name)") } # whats with that statements?
  validates :name,:description,:measure_units ,presence: true
  # validate :measure_units_count


  def measure_units_count
    if measure_units.count == 0
      errors.add(:measure_units, "Must have at least one mesure unit")
    end
  end
  # here could make to the classes that uses search that implement search to try DRYing the code
  # how about a search class?
  def self.search(query)
    return all if query.nil?
    if query.empty?
      all
    else
      where('name ilike ?', "%#{query}%")
    end
  end

end
