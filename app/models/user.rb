class User < ActiveRecord::Base
  has_many :constructions
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  ROLES = ['administrator','resident']
  validates :name,:phone,:role, :email, presence: true
  validates_format_of :name, :with => /[a-z]/, message: 'Ingresar sólo letras'
  validates :email, format: {
            with: %r{(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\Z}i,
            message: 'email invotra cosalido'
                  }
  # validate :validate_phone_number
#   validate :phone ,check which regex uses
  validates :phone, format: {
               with: %r{\+?\d{1,3}?[- .]?\(?(?:\d{2,3})\)?[- .]?\d\d\d[- .]?\d\d\d\d\Z}i,
               message: 'Invalid format'
                   } # no sirve
  validates :role, inclusion: ROLES
  paginates_per 10

  scope :resident, -> {where role: 'resident'}
  scope :administrator, -> {where role: 'administrator'}

  # def validate_phone_number
  #   if (:phone.length == 10) or (:phone.length == 12 && (:phone[0,2] == '55' or :phone[0,2] == '33' or :phone[0,2] == '88'))
  #     validates :phone, format: {with: %r{\+?\d{1,3}?[- .]?\(?(?:\d{2,3})\)?[- .]?\d\d\d[- .]?\d\d\d\d\Z}i}
  #   else if :phone.length == 12 && (:phone[0,2] == '55' or :phone[0,2] == '33' or :phone[0,2] == '88')
  #     validates :phone[2,12], format: {with: %r{\+?\d{1,3}?[- .]?\(?(?:\d{2,3})\)?[- .]?\d\d\d[- .]?\d\d\d\d\Z}i}
  #        else errors.add(:phone, "Teléfono inválido")
  #        end
  #   end
  # end
  def self.search(search)
    return all if search.nil?
    unless search.empty?
      where('LOWER(name) LIKE ?', "%#{search}%")
    else
      all
    end
  end
end
