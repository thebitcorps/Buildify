class PaymentsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @type_list = sanitized_type_list
    respond_to do |format|
      format.html {redirect_to construction_path(params[:construction_id]),type_list: params[:type_list]}
      format.js {@payments =(class_eval %Q{Payment.#{@type_list}(#{params[:construction_id]})})}
    end

  end

  private
  def sanitized_type_list
    Payment::STATUS.include?(params[:type_list]) ? params[:type_list] : 'all'
  end
end
