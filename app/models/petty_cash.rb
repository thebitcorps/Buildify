class PettyCash < ActiveRecord::Base
  belongs_to :construction
  has_many :petty_cash_expenses
  DEFAULT_AMOUNT = '1000'
  scope :with_construction, ->(construction_id) { where(construction_id: construction_id).order(created_at: :asc)}
end
