require "prawn/measurement_extensions"

pdf = Prawn::Document.new


logo_cell = pdf.make_cell image: "#{Rails.root}/app/assets/images/allpino_logo.png", image_width: 80, borders: [:left, :top]
head_cell = pdf.make_cell content: "<b>Madereria y Construcciones Allpino S.A De C.V</b><br>Agustin Yañez 141-1 PB Fracc. Villas De La Universidad<br>C.P. 20029 Aguascalientes, Ags. México<br>Tel. y Fax: 01-449-914-93-88<br>E-mail: allpino_cotizaciones@yahoo.com"
head_cell.style inline_format: true, align: :left, padding: [15, 15, 15, 0], borders: [:top, :right], size: 10
pdf.table [[logo_cell, head_cell]], width: pdf.bounds.width

title_cell = pdf.make_cell content: "<b>Contra Recibo</b>"
title_cell.style inline_format: true, align: :center, padding: [5, 0, 5, 0], borders: [:top, :left, :right]
pdf.table [[title_cell]], width: pdf.bounds.width

provider_title_cell = pdf.make_cell content: "Recibimos de"
provider_title_cell.style inline_format: true, align: :center, padding: [5, 0, 5, 0], borders: [:left], size: 10

folio_title_cell = pdf.make_cell content: "Con folio"
folio_title_cell.style inline_format: true, align: :center, padding: [5, 0, 0, 0], borders: [], size: 10

date_title_cell = pdf.make_cell content: "Fecha"
date_title_cell.style inline_format: true, align: :center, padding: [5, 0, 0, 0], borders: [:right], size: 10

provider_cell = pdf.make_cell content: "<b>#{@invoice.provider.name}</b>"
provider_cell.style inline_format: true, align: :center, padding: [0, 0, 5, 0], borders: [:left]

folio_cell = pdf.make_cell content: "<b>#{@invoice.folio}</b>"
folio_cell.style inline_format: true, align: :center, padding: [0, 0, 5, 0], borders: []

date_cell = pdf.make_cell content: "<b>#{spanish_formated_date @invoice.invoice_date, false}</b>"
date_cell.style inline_format: true, align: :center, padding: [0, 0, 5, 0], borders: [:right]

pdf.table [	[provider_title_cell, folio_title_cell, date_title_cell],
			[provider_cell, folio_cell, date_cell]], width: pdf.bounds.width

amount_title_cell = pdf.make_cell content: "Importe"
amount_title_cell.style inline_format: true, padding: [5, 0, 0, 10], borders: [:left, :top], border_lines: [:dashed, :solid, :solid, :solid]
amount_cell = pdf.make_cell content: "#{number_to_currency @invoice.amount}"
amount_cell.style inline_format: true, align: :right, padding: [5, 20, 5, 5], borders: [:right, :top], border_lines: [:dashed, :solid, :solid, :solid]

iva_title_cell = pdf.make_cell content: "IVA"
iva_title_cell.style inline_format: true, padding: [5, 0, 0, 10], borders: [:left]
iva_cell = pdf.make_cell content: "#{number_to_currency @invoice.amount * 0.16}"
iva_cell.style inline_format: true, align: :right, padding: [5, 20, 5, 5], borders: [:right]

total_title_cell = pdf.make_cell content: "<b>Total</b>"
total_title_cell.style inline_format: true, padding: [5, 0, 0, 10], borders: [:left, :top, :bottom], border_lines: [:dashed, :solid, :solid, :solid]
total_cell = pdf.make_cell content: "<b>#{number_to_currency @invoice.amount}</b>"
total_cell.style inline_format: true, align: :right, padding: [5, 20, 15, 5], borders: [:right, :top, :bottom], border_lines: [:dashed, :solid, :solid, :solid]

pdf.table [	[amount_title_cell, amount_cell],
			[iva_title_cell, iva_cell],
			[total_title_cell, total_cell]], width: pdf.bounds.width

inf_cell = pdf.make_cell content: "*Los dias de pago y revisión son los dias <b>lunes</b> de <b>9am</b> a <b>1pm</b>."
inf_cell.style inline_format: true, align: :right, size: 8

pdf.table [[inf_cell]], width: pdf.bounds.width

pdf.render