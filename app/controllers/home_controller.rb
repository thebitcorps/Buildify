class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @constructions = Construction.running
      @payments = Payment.all
  end

end
