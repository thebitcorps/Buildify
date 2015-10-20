class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #funky method, [:search][:query] could be non-existant
  def sanitized_search
    return '' if params[:search].nil?
    params[:search][:query].nil? ? '' : params[:search][:query]
  end

  def filter_sub_out
  end
end
