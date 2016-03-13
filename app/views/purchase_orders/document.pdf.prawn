require "prawn/measurement_extensions"
pdf = Prawn::Document.new(:page_layout => :landscape)

logo_cell = pdf.make_cell image: "#{Rails.root}/app/assets/images/allpino_logo_80px.png"
logo_cell.style borders: [], image_width: 55, width: 150, padding: [15, 0, -20, 10]
title_cell = pdf.make_cell content: "Orden de Compra"
title_cell.style inline_format: true, align: :left, padding: [35, 0, 0, 0], borders: [], size: 20

pdf.table [[logo_cell, title_cell]], width: pdf.bounds.width

head_cell = pdf.make_cell content: "<b>Madereria y Construcciones Allpino S.A De C.V</b><br>Agustin Yañez 141-1 PB Fracc. Villas De La Universidad<br>C.P. 20029 Aguascalientes, Ags. México<br>Tel. y Fax: 01-449-914-93-88<br>E-mail: allpino_cotizaciones@yahoo.com"
head_cell.style inline_format: true, align: :left, padding: [5, 0, 0, 0], borders: [], size: 11

date_cell = pdf.make_cell content: "<b>Fecha:</b>"
date_cell.style inline_format: true, align: :left, borders: [:bottom], size: 12, padding: [2, 5, 2, 5]
date_data_cell = pdf.make_cell content: "#{spanish_formated_date @purchase_order.created_at, false}"
date_data_cell.style inline_format: true, align: :left, borders: [:bottom], size: 12, padding: [2, 5, 2, 5]

folio_cell = pdf.make_cell content: "<b>Orden de Compra N°:</b>"
folio_cell.style inline_format: true, align: :left, borders: [:bottom], size: 12, padding: [2, 5, 2, 5]
folio_data_cell = pdf.make_cell content: "<b>#{@purchase_order.formated_folio}</b>"
folio_data_cell.style inline_format: true, align: :left, borders: [:bottom], size: 12, :text_color => "2A718C", padding: [2, 5, 2, 5]

deliver_cell = pdf.make_cell content: "<b>Requisición N°:</b>"
deliver_cell.style inline_format: true, align: :left, borders: [:bottom], size: 12, padding: [2, 5, 2, 5]
deliver_data_cell = pdf.make_cell content: "<b>#{@purchase_order.requisition.formated_folio}</b>"
deliver_data_cell.style inline_format: true, align: :left, borders: [:bottom], size: 12, :text_color => "2A718C", padding: [2, 5, 2, 5]

construction_cell = pdf.make_cell content: "<b>Obra:</b>"
construction_cell.style inline_format: true, align: :left, borders: [:bottom], size: 12, padding: [2, 5, 2, 5]
construction_data_cell = pdf.make_cell content: "#{@purchase_order.construction.title.length > 50 ? @purchase_order.construction.title[0..50].gsub(/\s\w+\s*$/,'...') : @purchase_order.construction.title}"
construction_data_cell.style inline_format: true, align: :left, borders: [:bottom], size: 12, padding: [2, 5, 2, 5]

inf_cell = pdf.make_cell [[date_cell, date_data_cell], [folio_cell, folio_data_cell], [deliver_cell, deliver_data_cell], [construction_cell, construction_data_cell]]
inf_cell.style inline_format: true, align: :center, borders: [:right, :top, :bottom, :left], border_widths: [2, 2, 2, 2], size: 12

pdf.table [[head_cell, inf_cell]], width: pdf.bounds.width

pdf.move_down 10

provider_cell = pdf.make_cell content: "<b>Proveedor:</b>"
provider_cell.style inline_format: true, align: :left, borders: [:bottom, :top, :left], border_widths: [2, 1, 1, 2], size: 12, padding: [2, 5, 2, 5], width: 150
provider_data_cell = pdf.make_cell content: "#{@purchase_order.provider.name}"
provider_data_cell.style inline_format: true, align: :left, borders: [:bottom, :top, :right], border_widths: [2, 2, 1, 1], size: 12, padding: [2, 5, 2, 5]

deliver_inf_cell = pdf.make_cell content: "<b>Entregar a:</b>"
deliver_inf_cell.style inline_format: true, align: :left, borders: [:bottom, :left], border_widths: [1, 1, 1, 2], size: 12, padding: [2, 5, 2, 5], width: 150
deliver_inf_data_cell = pdf.make_cell content: "#{@purchase_order.delivery_receiver}"
deliver_inf_data_cell.style inline_format: true, align: :left, borders: [:bottom, :right], border_widths: [1, 2, 1, 1], size: 12, padding: [2, 5, 2, 5]

deliver_address_cell = pdf.make_cell content: "<b>#{@purchase_order.delivery_place != "pick_up" ? "Recoger con proveedor:" : "Enviar a obra:"}</b>"
deliver_address_cell.style inline_format: true, align: :left, borders: [:bottom, :left], border_widths: [1, 1, 2, 2], size: 12, padding: [2, 5, 2, 5], width: 150
deliver_address_data_cell = pdf.make_cell content: "#{@purchase_order.delivery_address}"
deliver_address_data_cell.style inline_format: true, align: :left, borders: [:bottom, :right], border_widths: [1, 2, 2, 1], size: 12, padding: [2, 5, 2, 5]


pdf.table [[provider_cell, provider_data_cell], [deliver_inf_cell, deliver_inf_data_cell], [deliver_address_cell, deliver_address_data_cell]], width: pdf.bounds.width

pdf.render
