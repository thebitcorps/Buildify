class Material < ActiveRecord::Base
  has_many :item_materials
  paginates_per 30
  has_many :permitted_measure_units,dependent: :destroy
  has_many :measure_units, through: :permitted_measure_units
  scope :all_alphabetical, -> { all.order(name: :asc) } # whats with that statements?
  scope :pending, -> { where description: ''} # whats with that statements?
  validates :name ,:measure_units ,presence: true
  validates :name ,uniqueness: true

  # here could make to the classes that uses search that implement search to try DRYing the code
  # how about a search class?
  def self.search(query)
    return all if query.nil?
    if query.empty?
      all
    else
      where('name ilike ? OR description ilike ?' , "%#{query}%","%#{query}%").order(name: :asc)
    end
  end

end
