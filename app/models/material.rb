class Material < ActiveRecord::Base
  has_many :item_materials
  paginates_per 30
  has_many :permitted_measure_units,dependent: :destroy
  has_many :measure_units, through: :permitted_measure_units
  # default_scope {order(name: :asc)}
  scope :pending, -> { where description: ''} # whats with that statements?
  validates :name ,:measure_units ,presence: true
  # validates :name ,uniqueness: true

  # here could make to the classes that uses search that implement search to try DRYing the code
  # how about a search class?
  scope :search , ->(search){
    if search.blank?
      all
    else
      # y tried with joined name and description and works better the other way att llams
      # joined_name = '(name || \' \' || description)'
      # includes(:measure_units).where("similarity(#{joined_name}, ?) > 0.3", search).order("similarity(#{joined_name}, #{ActiveRecord::Base.connection.quote(search)}) DESC")
      includes(:measure_units).where("similarity(name, ?) > 0.3 OR similarity(name, ?) > 0.3", search,search).order("similarity(name, #{ActiveRecord::Base.connection.quote(search)}) DESC")
    end
  }



end
