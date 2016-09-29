require "prawn/measurement_extensions"

pdf = Prawn::Document.new(:page_layout => :landscape)

logo_cell = pdf.make_cell image: "#{Rails.root}/app/assets/images/allpino_logo_80px.png"
logo_cell.style borders: [], image_width: 55, width: 150, padding: [15, 0, -20, 10]
title_cell = pdf.make_cell content: "Contra Recibo"
title_cell.style inline_format: true, align: :left, padding: [35, 0, 0, 0], borders: [], size: 20

pdf.table [[logo_cell, title_cell]], width: pdf.bounds.width

head_cell = pdf.make_cell content: "<b>Madereria y Construcciones Allpino S.A De C.V</b><br>Agustin Yañez 141-1 PB Fracc. Villas De La Universidad<br>C.P. 20029 Aguascalientes, Ags. México<br>Tel. y Fax: 01-449-914-93-88<br>E-mail: allpino_cotizaciones@yahoo.com"
head_cell.style inline_format: true, align: :left, padding: [5, 0, 0, 0], borders: [], size: 11

date_cell = pdf.make_cell content: "<b>Fecha:</b>"
date_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, padding: [2, 5, 2, 5]
date_data_cell = pdf.make_cell content: "#{spanish_formated_date @invoice.invoice_date, false}"
date_data_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, padding: [2, 5, 2, 5]

folio_cell = pdf.make_cell content: "<b>Contra Recibo N°:</b>"
folio_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, padding: [2, 5, 2, 5]
folio_data_cell = pdf.make_cell content: "<b>#{@invoice.folio}</b>"
folio_data_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, :text_color => "2A718C", padding: [2, 5, 2, 5]

deliver_cell = pdf.make_cell content: "<b>Recibimos de:</b>"
deliver_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, padding: [2, 5, 2, 5]
deliver_data_cell = pdf.make_cell content: "#{@invoice.provider.name.length > 55 ? @invoice.provider.name[0..55].gsub(/\s\w+\s*$/,'...') : @invoice.provider.name}"
deliver_data_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, padding: [2, 5, 2, 5]

construction_cell = pdf.make_cell content: "<b>Obra:</b>"
construction_cell.style inline_format: true, align: :left, borders: [], size: 11, padding: [2, 5, 2, 5]
construction_data_cell = pdf.make_cell content: "#{@invoice.construction.title.length > 55 ? @invoice.construction.title[0..55].gsub(/\s\w+\s*$/,'...') : @invoice.construction.title}"
construction_data_cell.style inline_format: true, align: :left, borders: [], size: 11, padding: [2, 5, 2, 5]

inf_cell = pdf.make_cell [[date_cell, date_data_cell], [folio_cell, folio_data_cell], [deliver_cell, deliver_data_cell], [construction_cell, construction_data_cell]]
inf_cell.style inline_format: true, align: :center, borders: [:right, :top, :bottom, :left], border_widths: [2, 2, 2, 2], size: 11

pdf.table [[head_cell, inf_cell]], width: pdf.bounds.width

pdf.move_down 5.mm

items_title = pdf.make_cell content: "<b>Folio</b>"
items_title.style inline_format: true, align: :center, borders: [:left, :top, :bottom, :right], border_widths: [2, 2, 2, 2], size: 10, width: 130
items_title2 = pdf.make_cell content: "<b>Fecha</b>"
items_title2.style inline_format: true, align: :center, borders: [:top, :bottom, :right], border_widths: [2, 2, 2, 2], size: 10
items_title3 = pdf.make_cell content: "<b>Folio de factura</b>"
items_title3.style inline_format: true, align: :center, borders: [:top, :bottom, :right], border_widths: [2, 2, 2, 2], size: 10
items_title4 = pdf.make_cell content: "<b>Importe</b>"
items_title4.style inline_format: true, align: :center, borders: [:top, :bottom, :right], border_widths: [2, 2, 2, 2], size: 10, width: 130

rows = [[items_title, items_title2, items_title3, items_title4]]

items_title = pdf.make_cell content: ""
items_title.style inline_format: true, align: :center, borders: [:bottom], border_widths: [2, 2, 2, 2], size: 10, width: 130
items_title2 = pdf.make_cell content: ""
items_title2.style inline_format: true, align: :center, borders: [:bottom], border_widths: [2, 2, 2, 2], size: 10, width: 50
items_title3 = pdf.make_cell content: ""
items_title3.style inline_format: true, align: :center, borders: [:bottom], border_widths: [2, 2, 2, 2], size: 10, width: 130

rows<<[items_title, items_title2, items_title3]

items_title = pdf.make_cell content: "#{@invoice.folio}"
items_title.style inline_format: true, padding: [5, 0, 5, 0], align: :center, borders: [:left, :bottom, :right], border_widths: [1, 2, 2, 2], size: 10, width: 130
items_title2 = pdf.make_cell content: "#{@invoice.invoice_date}"
items_title2.style inline_format: true, padding: [5, 0, 5, 0], align: :center, borders: [:left, :bottom, :right], border_widths: [1, 2, 2, 2], size: 10
items_title3 = pdf.make_cell content: "#{@invoice.receipt_folio}"
items_title3.style inline_format: true, padding: [5, 0, 5, 0], align: :center, borders: [:left, :bottom, :right], border_widths: [1, 2, 2, 2], size: 10, width: 50
items_title4 = pdf.make_cell content: "#{number_to_currency @invoice.amount}"
items_title4.style inline_format: true, padding: [5, 0, 5, 0], align: :center, borders: [:left, :bottom, :right, :top], border_widths: [2, 2, 1, 2], size: 10, width: 130

rows<<[items_title, items_title2, items_title3, items_title4]

items_title = pdf.make_cell content: ""
items_title.style inline_format: true, padding: [5, 0, 5, 0], align: :center, borders: [], border_widths: [1, 2, 1, 2], size: 10, width: 130
items_title2 = pdf.make_cell content: "<b>IVA:</b>"
items_title2.style inline_format: true, padding: [5, 10, 5, 5], align: :right, borders: [], border_widths: [1, 2, 1, 2], size: 10
items_title3 = pdf.make_cell content: "#{number_to_currency @invoice.amount * 0.16}"
items_title3.style inline_format: true, padding: [5, 0, 5, 0], align: :center, borders: [:left, :bottom, :right], border_widths: [1, 2, 1, 2], size: 10, width: 130

rows<<[items_title, items_title, items_title2, items_title3]

items_title = pdf.make_cell content: ""
items_title.style inline_format: true, padding: [5, 0, 5, 0], align: :center, borders: [], border_widths: [1, 2, 1, 2], size: 10, width: 130
items_title2 = pdf.make_cell content: "<b>Total:</b>"
items_title2.style inline_format: true, padding: [5, 10, 5, 5], align: :right, borders: [], border_widths: [1, 2, 1, 2], size: 10
items_title3 = pdf.make_cell content: "<b>#{number_to_currency @invoice.amount}</b>"
items_title3.style inline_format: true, padding: [5, 0, 5, 0], align: :center, borders: [:left, :bottom, :right, :top], border_widths: [2, 2, 2, 2], size: 10, width: 130

rows<<[items_title, items_title, items_title2, items_title3]

pdf.table rows, width: pdf.bounds.width - 20

pdf.move_down 5.mm

obs_cell = pdf.make_cell content: "Observaciones:"
obs_cell.style inline_format: true, borders: [:top, :right, :bottom, :left], border_widths: [2, 2, 2, 2], size: 10, padding: [5, 5, 5, 5]

pdf.table [[obs_cell]], width: pdf.bounds.width

pdf.move_down 2.mm

high_inf_cell = pdf.make_cell content: "*Los dias de pago y revisión son los dias <b>lunes</b> de <b>9am</b> a <b>1pm</b>"
high_inf_cell.style inline_format: true, align: :center, borders: [:top, :right, :bottom, :left], border_widths: [2, 2, 2, 2], size: 10, padding: [5, 5, 5, 5]

pdf.table [[high_inf_cell]], width: pdf.bounds.width

pdf.move_down 2.mm

auth_empty_cell = pdf.make_cell content: ""
auth_empty_cell.style inline_format: true, align: :center, borders: [:right, :top, :left], border_widths: [2, 2, 2, 2], height: 50, size: 11

pdf.table [[auth_empty_cell]], width: pdf.bounds.width

f1 = pdf.make_cell content: ""
f1.style borders: [:left, :bottom], border_widths: [2, 2, 2, 2]
auth_cell = pdf.make_cell content: "Frima"
auth_cell.style inline_format: true, align: :center, borders: [:bottom, :top], border_widths: [1, 2, 2, 2], size: 10
f2 = pdf.make_cell content: ""
f2.style borders: [:bottom, :right], border_widths: [2, 2, 2, 2], size: 11

pdf.table [[f1, auth_cell, f2]], width: pdf.bounds.width


pdf.render