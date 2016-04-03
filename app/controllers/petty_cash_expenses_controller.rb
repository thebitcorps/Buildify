class PettyCashExpensesController < ApplicationController
  before_filter :authenticate_user!
  def show
    @petty_cash_expense = PettyCashExpense.find params[:id]
  end
  def create
    @petty_cash_expense = PettyCashExpense.new petty_cash_expense_params
    respond_to do |format|
      if @petty_cash_expense.save
        format.json {render  :show,status: :ok,location: @petty_cash_expense}
      else
        format.json { render json: JSON.parse(@petty_cash_expense.errors.full_messages.to_json), status: :unprocessable_entity}
      end
    end
  end
private
  def petty_cash_expense_params
    params.require(:petty_cash_expense).permit(:concept,:amount,:expense_date,:observation,:petty_cash_id )
  end
end
