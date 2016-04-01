class PettyCash < ActiveRecord::Base
  belongs_to :construction
  has_many :petty_cash_expenses,dependent: :destroy
  DEFAULT_AMOUNT = '1000'
  validates :construction_id,:amount, presence: true
  validates :amount, numericality: true

  before_create :close_petty_cash

  scope :active_from_construction, ->(construction_id) { where(construction_id: construction_id).order(created_at: :asc).last}
  scope :with_construction, ->(construction_id) { where(construction_id: construction_id).order(created_at: :desc)}

  # close last last petty cash before from a construction
  def close_petty_cash
    last_petty_chash = PettyCash.active_from_construction self.construction_id
    return if last_petty_chash.empty?
    last_petty_chash.closing_date = Time.now
    last_petty_chash.save
  end
end
