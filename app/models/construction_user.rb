class ConstructionUser < ActiveRecord::Base
  belongs_to :construction
  belongs_to :user
  PRINCIPAL_ROLE = 'principal'
  RESIDENT_ROLE = 'resident'
  ASSISTANT_ROLE = 'assinstant'
  ROLES = [PRINCIPAL_ROLE,RESIDENT_ROLE,ASSISTANT_ROLE]
  validates :user_id,:role, presence: true

end
