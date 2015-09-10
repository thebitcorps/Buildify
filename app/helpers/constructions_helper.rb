module ConstructionsHelper

  def day_color(date)
    return 'default' if date == nil
    today = Date.today
    if date > today
      'default'
    elsif date == today
      'primary'
    elsif date < today
      'warning'
    end
  end
end
