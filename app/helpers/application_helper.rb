module ApplicationHelper
  @@spanish_months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
  @@spanish_days = ["Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"]
  
  def spanish_formated_date(date, short)
    if short
      [date.day, @@spanish_months[date.month - 1], date.year].join("/")
    else
      [@@spanish_days[date.wday], [date.day, @@spanish_months[date.month - 1], date.year].join("/")].join(", ")
    end
  end

  def percentage_of_number(number, top)
    percentage = 100.0 / top * number
    percentage > 100.0 ? 100.0 : percentage
  end
end
