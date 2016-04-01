class PettyCashExpense < ActiveRecord::Base
  belongs_to :petty_cash
  validates :amount,:concept,:expense_date,:petty_cash_id,presence: true
  validates :amount, numericality: true
end
