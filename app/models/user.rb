class User < ActiveRecord::Base
  has_many :construction_users
  has_many :constructions, through: :construction_users
  has_many :construction_administrations, class_name: 'Construction', source: :construction, foreign_key: :user_id
  has_many :administrated_requisitions, through: :construction_administrations, source: :requisitions
  has_many :requisitions

  # Not sure about this
  #has_many :residents, class_name: 'User', through: :construction_users, foreign_key: :user_id, source: :user

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  ROLES = ['administrator','subordinate','secretary']
  royce_roles ROLES

  validates :name, :phone, :email, presence: true
  validates_format_of :name, :with => /[a-z]/, message: 'Ingresar sólo letras'
  validates :email, format: { with: %r{(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\Z}i, message: 'Email inválido' } #fucking message does not show salavabinch
  validates :phone, format: { with: %r{\+?\d{1,3}?[- .]?\(?(?:\d{2,3})\)?[- .]?\d\d\d[- .]?\d\d\d\d\Z}i, message: 'Teléfono inválido' }
  paginates_per 10

  before_save name.humanize

  def partial_requisitions(construction_id=nil)
    get_requisitions :partially,construction_id
  end

  def pending_requisitions(construction_id=nil)
    get_requisitions :pending,construction_id

  end

  def complete_requisitions(construction_id=nil)
    get_requisitions :complete,construction_id
  end
  def get_requisitions(status,construction_id)
    requisitions = self.requisitions.where status: status
    requisitions = requisitions.where construction_id: construction_id unless construction_id.nil?
    requisitions
  end

  def self.search(search)
    return all if search.nil?
    if search.empty?
      all.order(name: :asc)
    else
      where('name ilike ?', "%#{search}%").order(name: :asc)
    end
  end

  # we dont let users have multiples role
  # maybe we could change so users can have multiple roles? atte llamas
  def change_role(role)
    role_list.each do |old_role|
      remove_role old_role
    end
    add_role role
  end
end
