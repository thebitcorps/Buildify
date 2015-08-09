class ExpensesController < ApplicationController

  def index
    @expenses = Expense.all
  end

  def update
    @expense = Expense.find(params[:id])
    if @expense.update(expense_params)
      redirect_to construction_path(@expense.construction)
    end
  end

  private

    def expense_params
      params.require(:expense).permit(:concept, :amount_paid, :check_number)
    end

end
