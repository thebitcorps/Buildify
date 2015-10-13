class User < ActiveRecord::Base
  has_many :constructions,through: :construction_users
  has_many :residents, class_name: 'User',through: :construction_users,foreign_key: :user_id,source: :user
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  ROLES = ['administrator','resident']
  validates :name,:phone,:role, :email, presence: true
  validates_format_of :name, :with => /[a-z]/, message: 'Ingresar sólo letras'

  validates :email, format: {
              with: %r{(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\Z}i,
              message: 'Email inválido' #fucking message does not show salavabinch
                   }

  validates :phone, format: {
               with: %r{\+?\d{1,3}?[- .]?\(?(?:\d{2,3})\)?[- .]?\d\d\d[- .]?\d\d\d\d\Z}i,
               message: 'Teléfono inválido'
                   }

  validates :role, inclusion: ROLES
  paginates_per 10

  scope :residents, -> { where role: 'resident' }
  scope :administrator, -> { where role: 'administrator' }

  def self.search(search)
    return all if search.nil?
    if search.empty?
      all
    else
      where('name ilike ?', "%#{search}%")
    end
  end
end
