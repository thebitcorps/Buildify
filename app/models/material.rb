class Material < ActiveRecord::Base
  has_many :item_materials
  paginates_per 10
  scope :all_alphabetical, -> { all.order("LOWER(name)") } # whats with that statements?

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
