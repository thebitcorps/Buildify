module ApplicationHelper
  @@spanish_months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
  @@spanish_days = ["Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"]
  
  def spanish_formated_date(date, short)
    if short
      [date.day, @@spanish_months[date.month - 1], date.year].join("/")
    else
      [@@spanish_days[date.wday].downcase, [date.day, @@spanish_months[date.month - 1].downcase, date.year].join(" de ")].join(", ")
    end
  end

  def percentage_of_number(number, top)
    percentage = 100.0 / top * number
    percentage > 100.0 ? 100.0 : percentage
  end

  # put this as application helper to dry code
  # or should it be in purchase_order.rb and requisition.rb?
  def self.change_item_material_status(object,new_status)
    object.item_materials.each do |item_material|
      item_material.status = new_status
      item_material.save
    end
  end

  def are_you_signed_clack_or_not(boolean)
    if boolean
      content_tag(:i, nil, class: 'fa fa-check-square green', data: { toggle: 'tooltip', placement: 'bottom' }, title: 'Firmada')
    else
      content_tag(:i, nil, class: 'fa fa-check-minus red', data: { toggle: 'tooltip', placement: 'bottom' }, title: 'Sin firmar')
    end
  end
end
