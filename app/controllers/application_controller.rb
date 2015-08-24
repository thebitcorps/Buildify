class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sanitaze_search
    return '' if params[:search].nil?
    params[:search][:search].nil? ? '' : params[:search][:search]
  end
end
