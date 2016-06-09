class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def seen
    @notification = Notification.find params[:id]
    if @notification.seen!
      redirect_to @notification.redirect_to_object
    else
      redirect_to root_path, alert: 'Error'
    end
  end
end