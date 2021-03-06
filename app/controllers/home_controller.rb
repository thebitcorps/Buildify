class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    case current_user.get_role
    when 'administrator'
      @activities = PublicActivity::Activity.all.order(created_at: :desc).limit(15)
      @constructions = Construction.running
      @payments = Payment.active.page(params[:payment_page])
      @balance = get_expenses(@constructions)
    when 'subordinate'
      @requisitions = current_user.requisitions
      @constructions = Construction.owned_by(current_user) || []
    when 'secretary'
      @payments = Payment.active.page(params[:payment_page])
      @purchase_orders = PurchaseOrder.active.page(params[:page])                
    end
  end

  private

  # method that extract all the expenses from the given construction array
  # return: hash with keys expeneses and paid with the sum of all the expeneses and paid
  def get_expenses(constructions)
    information = {expenses: 0, paid: 0}
    constructions.each do |construction|
      information[:expenses] += construction.expenses
      information[:paid] += construction.paid
    end
    information
  end
end
