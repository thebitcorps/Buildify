class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  def index
    @notifications = current_user.notifications
  end

  def seen
    notification = Notification.find params[:id]
    if notification.seen!
      redirect_to notification.redirect_to_object
    else
      redirect_to root_path, alert: 'Error'
    end
  end

  def seen_all
    current_user.clean_notifications
    render action: :seen_all
  end
end
