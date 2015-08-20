class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  ROLES = ['administrator','resident']
  validates :name,:phone,:role, presence: true
#   validate :phone ,check which regex uses
  validates :role, inclusion: ROLES


  def self.administrators
    where role: 'administrator'
  end

  def self.residents
    where role: 'resident'
  end


end
