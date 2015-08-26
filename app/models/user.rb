class User < ActiveRecord::Base
  has_many :constructions
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  ROLES = ['administrator','resident']
  validates :name,:phone,:role, presence: true
#   validate :phone ,check which regex uses
  validates :phone, format: {
                with: %r{\+?\d{1,3}?[- .]?\(?(?:\d{2,3})\)?[- .]?\d\d\d[- .]?\d\d\d\d\Z}i,
                message: 'Invalid format'
                  } #no sirve
  validates :role, inclusion: ROLES
  paginates_per 10

  scope :resident, -> {where role: 'resident'}
  scope :administrator, -> {where role: 'administrator'}

  def self.search(search)
    return all if search.nil?
    unless search.empty?
      where('LOWER(name) LIKE ?', "%#{search}%")
    else
      all
    end
  end


end
