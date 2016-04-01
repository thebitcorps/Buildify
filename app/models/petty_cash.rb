class PettyCash < ActiveRecord::Base
  belongs_to :construction
  has_many :petty_cash_expenses,dependent: :destroy
  DEFAULT_AMOUNT = '1000'
  validates :construction_id,:amount, presence: true
  validates :amount, numericality: true

  scope :active_from_construction, ->(construction_id) { where(construction_id: construction_id).order(created_at: :asc).last}
  scope :with_construction, ->(construction_id) { where(construction_id: construction_id).order(created_at: :desc)}
end
