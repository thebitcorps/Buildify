class Notification < ActiveRecord::Base
  ##################  Active model   ##################
  belongs_to :user
  belongs_to :activity,class_name: 'PublicActivity::Activity',foreign_key: :activity_id

  ##################  Validations   ##################
  validates :user_id, :activity_id, presence: true

  ##################  Methods/Scopes   ##################
  default_scope {order(created_at: :desc)}
  scope :unseen, -> {where(seen: false)}
  scope :seen, -> {where(seen: true)}
  def seen!
    update_column :seen,true
  end

  ##################  Class Methods   ##################
  def self.notify_admins(public_activity)
    User.administrators.each do |admin|
      Notification.create(user: admin,activity: public_activity)
    end
  end

  def self.notify_residents(public_activity, construction)
    Notification.create(user: construction.manager,activity: public_activity)
    construction.residents.each do |resident|
      Notification.create(user: resident,activity: public_activity)
    end
  end
end
