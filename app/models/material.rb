class Material < ActiveRecord::Base
  has_many :item_materials
  paginates_per 10
  has_many :permitted_mesure_units
  has_many :mesure_units, through: :permitted_mesure_units
  scope :all_alphabetical, -> { all.order("LOWER(name)") } # whats with that statements?
  validates :name,:description ,presence: true
  validate :mesure_units_count


  def mesure_units_count
    if mesure_units.count == 0
      errors.add(:mesure_units, "Must have at least one mesure unit")
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
