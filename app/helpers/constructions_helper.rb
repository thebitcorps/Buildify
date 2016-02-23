module ConstructionsHelper

  @@spanish_status = {'running' => 'En proceso', 'stopped' => 'Detenida ', 'finished' => 'Termindada'}

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
    construction.contract_amount = 1 if construction.contract_amount.nil?
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

  def construction_spanish_status(construction)
    @@spanish_status[construction.status]
  end


  def construction_or_office_path(construction)
    if construction.office?
      office_path(construction)
    else
      construction_path(construction)
    end
  end
end
