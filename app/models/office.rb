class Office < Construction
  # Methods, variables and constants
  validates :title,:address,:contract_amount,:manager, presence: false

  before_save :create_title

  def create_title
    self.title = "Oficina #{self.start_date} hasta #{self.finish_date}"
  end
end