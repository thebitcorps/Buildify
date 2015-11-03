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

  def days_bar_tag_class(construction)
    if construction.available_days > construction.days_passed
      "progress-bar-info"
    else
      "progress-bar-warning"
    end
  end

  def amount_tag_class(construction)
    if construction.estimates_amount < construction.contract_amount
      if construction.estimates_amount < construction.contract_amount / 2
        "label-danger"
      else
        "label-warning"
      end
    else
      "label-success"
    end
  end

  def expenses_amount_tag(construction)
    expenses =  construction.expenses
    if expenses <= construction.contract_amount / 2
      'label-success'
    elsif expenses > construction.contract_amount / 2
      'label-warning'
    else
      'label-danger'
    end

  end



  def amount_color_class(construction)
    if construction.estimates_amount < construction.contract_amount
      if construction.estimates_amount < construction.contract_amount / 2
        "text-danger"
      else
        "text-warning"
      end
    else
      "text-success"
    end
  end
end
