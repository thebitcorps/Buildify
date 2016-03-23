class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    if current_user.administrator?
      @constructions = Construction.running
      @payments = Payment.all
      @balance = get_expenses(@constructions)
    elsif current_user.subordinate?
      @requisitions = current_user.requisitions
    elsif current_user.secretary?
      @payments = Payment.all
    end

  end
  private
  # method that extract all the expenses from the given construction array
  # return: hash with keys expeneses and paid with the sum of all the expeneses and paid
  def get_expenses(constructions)
    information = {}
    information[:expenses] = 0
    information[:paid] = 0
    constructions.each do |construction|
      information[:expenses] += construction.expenses
      information[:paid] += construction.paid
    end
    information
  end

end
