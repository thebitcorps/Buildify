class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #future refact
  #funky method, [:search][:query] could be non-existant
  def sanitized_search
    return '' if params[:search].nil?
    params[:search][:query].nil? ? '' : params[:search][:query]
  end

  def filter_sub_out
    if current_user.subordinate?
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'No tiene permisos para acceder esta parte del sito.' }
      end
    end
  end
end
