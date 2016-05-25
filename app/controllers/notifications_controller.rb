class NotificationsController < ApplicationController
  def seen
    @notification = Notification.find params[:id]
    if @notification.seen!
      redirect_to @notification.activity.trackable
    else
      redirect_to root_path, alert: 'Errorr'
    end
  end
end
