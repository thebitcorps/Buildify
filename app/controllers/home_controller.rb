class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @payments = Payment.all
  end

end
