class HomeController < ApplicationController

  def index
    @payments = Payment.all
  end

end
