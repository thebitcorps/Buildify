class Estimate < ActiveRecord::Base
  include AASM
  belongs_to :construction
  validates :amount,:concept, :extension_date, presence: true
  validates :amount, numericality: {message: 'Monto debe ser numerico'}
  before_destroy :substract_contruction_amount

  aasm :column => 'status'
  aasm :whiny_transitions => false
  aasm do
    state :pending, initial: true
    state :completed
    # should be authorize to be stamp, this could change
    event :complete, :after => :add_construction_amount do
      transitions :from =>  :pending, :to => :completed
    end
  end

  def substract_contruction_amount
    construction.update_column(:estimates_amount , construction.estimates_amount - amount)
  end

  def add_construction_amount
    construction.update_column(:estimates_amount , construction.estimates_amount + amount)
  end
end
