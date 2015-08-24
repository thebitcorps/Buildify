class Material < ActiveRecord::Base
  has_many :item_materials
  paginates_per 10
  scope :all_alphabetical, -> { all.order("LOWER(name)") }

  # here could make to the classes that uses search that implement search to try DRYing the code
  def self.search(search)
    return all if search.nil?
    unless search.empty?
      where('LOWER(name) LIKE ?', "%#{search}%")
    else
      all
    end
  end

end
