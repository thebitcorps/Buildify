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
  scope :from_user, ->(user_id) {where(user_id: user_id)}
  def seen!
    update_column :seen,true
  end

  def seen?
    seen
  end

  def redirect_to_object
    case activity.trackable
      when PurchaseOrder
        user.secretary? ? activity.trackable : activity.trackable.requisition
      when nil
        '/'
      else
        activity.trackable
    end

  end

  ##################  Class Methods   ##################
  def self.notify_admins(public_activity)
    User.administrators.each do |admin|
      Notification.create(user: admin,activity: public_activity)
    end
  end

  # we pass the construction so we can get the helpers user to notify them
  def self.notify_residents(public_activity, construction)
    Notification.create(user: construction.manager,activity: public_activity)
    construction.residents.each do |resident|
      Notification.create(user: resident,activity: public_activity) unless resident.access_locked?
    end
  end

  def self.notify_secretary(public_activity)
    User.secretaries.each do |secretary|
      Notification.create(user: secretary, activity: public_activity) unless secretary.access_locked?
    end
  end

end
