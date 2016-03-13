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
date_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, padding: [2, 5, 2, 5]
date_data_cell = pdf.make_cell content: "#{spanish_formated_date @purchase_order.created_at, false}"
date_data_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, padding: [2, 5, 2, 5]

folio_cell = pdf.make_cell content: "<b>Orden de Compra N°:</b>"
folio_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, padding: [2, 5, 2, 5]
folio_data_cell = pdf.make_cell content: "<b>#{@purchase_order.formated_folio}</b>"
folio_data_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, :text_color => "2A718C", padding: [2, 5, 2, 5]

deliver_cell = pdf.make_cell content: "<b>Requisición N°:</b>"
deliver_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, padding: [2, 5, 2, 5]
deliver_data_cell = pdf.make_cell content: "<b>#{@purchase_order.requisition.formated_folio}</b>"
deliver_data_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, :text_color => "2A718C", padding: [2, 5, 2, 5]

construction_cell = pdf.make_cell content: "<b>Obra:</b>"
construction_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, padding: [2, 5, 2, 5]
construction_data_cell = pdf.make_cell content: "#{@purchase_order.construction.title.length > 50 ? @purchase_order.construction.title[0..50].gsub(/\s\w+\s*$/,'...') : @purchase_order.construction.title}"
construction_data_cell.style inline_format: true, align: :left, borders: [:bottom], size: 11, padding: [2, 5, 2, 5]

inf_cell = pdf.make_cell [[date_cell, date_data_cell], [folio_cell, folio_data_cell], [deliver_cell, deliver_data_cell], [construction_cell, construction_data_cell]]
inf_cell.style inline_format: true, align: :center, borders: [:right, :top, :bottom, :left], border_widths: [2, 2, 2, 2], size: 11

pdf.table [[head_cell, inf_cell]], width: pdf.bounds.width

pdf.move_down 10

provider_cell = pdf.make_cell content: "<b>Proveedor:</b>"
provider_cell.style inline_format: true, align: :left, borders: [:bottom, :top, :left], border_widths: [2, 1, 1, 2], size: 11, padding: [2, 5, 2, 5], width: 140
provider_data_cell = pdf.make_cell content: "#{@purchase_order.provider.name}"
provider_data_cell.style inline_format: true, align: :left, borders: [:bottom, :top, :right], border_widths: [2, 2, 1, 1], size: 11, padding: [2, 5, 2, 5]

deliver_inf_cell = pdf.make_cell content: "<b>Entregar a:</b>"
deliver_inf_cell.style inline_format: true, align: :left, borders: [:bottom, :left], border_widths: [1, 1, 1, 2], size: 11, padding: [2, 5, 2, 5], width: 140
deliver_inf_data_cell = pdf.make_cell content: "#{@purchase_order.delivery_receiver}"
deliver_inf_data_cell.style inline_format: true, align: :left, borders: [:bottom, :right], border_widths: [1, 2, 1, 1], size: 11, padding: [2, 5, 2, 5]

deliver_address_cell = pdf.make_cell content: "<b>#{@purchase_order.delivery_place != "pick_up" ? "Recoger con proveedor:" : "Enviar a obra:"}</b>"
deliver_address_cell.style inline_format: true, align: :left, borders: [:bottom, :left], border_widths: [1, 1, 2, 2], size: 11, padding: [2, 5, 2, 5], width: 140
deliver_address_data_cell = pdf.make_cell content: "#{@purchase_order.delivery_address}"
deliver_address_data_cell.style inline_format: true, align: :left, borders: [:bottom, :right], border_widths: [1, 2, 2, 1], size: 11	, padding: [2, 5, 2, 5]

pdf.table [[provider_cell, provider_data_cell], [deliver_inf_cell, deliver_inf_data_cell], [deliver_address_cell, deliver_address_data_cell]], width: pdf.bounds.width

pdf.move_down 5.mm

items_title = pdf.make_cell content: "<b>Cantidad</b>"
items_title.style inline_format: true, align: :center, borders: [:left, :top, :bottom, :right], border_widths: [2, 2, 2, 2], size: 10
items_title2 = pdf.make_cell content: "<b>Unidad</b>"
items_title2.style inline_format: true, align: :center, borders: [:top, :bottom, :right], border_widths: [2, 2, 2, 2], size: 10
items_title3 = pdf.make_cell content: "<b>Descripción</b>"
items_title3.style inline_format: true, align: :center, borders: [:top, :bottom, :right], border_widths: [2, 2, 2, 2], size: 10
items_title4 = pdf.make_cell content: "<b>P Unitario</b>"
items_title4.style inline_format: true, align: :center, borders: [:top, :bottom, :right], border_widths: [2, 2, 2, 2], size: 10
items_title5 = pdf.make_cell content: "<b>Importe</b>"
items_title5.style inline_format: true, align: :center, borders: [:top, :bottom, :right], border_widths: [2, 2, 2, 2], size: 10
items_title6 = pdf.make_cell content: "<b>Factura</b>"
items_title6.style inline_format: true, align: :center, borders: [:top, :bottom, :right], border_widths: [2, 2, 2, 2], size: 10

rows = [[items_title, items_title2, items_title3, items_title4, items_title5, items_title6]]

items_title = pdf.make_cell content: ""
items_title.style inline_format: true, align: :center, borders: [:bottom], border_widths: [2, 2, 2, 2], size: 10
items_title2 = pdf.make_cell content: ""
items_title2.style inline_format: true, align: :center, borders: [:bottom], border_widths: [2, 2, 2, 2], size: 10
items_title3 = pdf.make_cell content: ""
items_title3.style inline_format: true, align: :center, borders: [:bottom], border_widths: [2, 2, 2, 2], size: 10
items_title4 = pdf.make_cell content: ""
items_title4.style inline_format: true, align: :center, borders: [:bottom], border_widths: [2, 2, 2, 2], size: 10
items_title5 = pdf.make_cell content: ""
items_title5.style inline_format: true, align: :center, borders: [:bottom], border_widths: [2, 2, 2, 2], size: 10
items_title6 = pdf.make_cell content: ""
items_title6.style inline_format: true, align: :center, borders: [:bottom], border_widths: [2, 2, 2, 2], size: 10

rows<<[items_title, items_title2, items_title3, items_title4, items_title5, items_title6]

total = 0

@purchase_order.item_materials.each_with_index do |item, index|
	total += item.unit_price != nil ? item.requested * item.unit_price : 0
	item_q_cell = pdf.make_cell content: "#{item.requested}"
	item_q_cell.style inline_format: true, padding: [2, 2, 2, 2], align: :center, borders: [:left, :bottom, :right], border_widths: [1, 2, 1, 2], size: 10
	item_u_cell = pdf.make_cell content: "#{item.measure_unit}"
	item_u_cell.style inline_format: true, padding: [2, 2, 2, 2], align: :center, borders: [:left, :bottom, :right], border_widths: [1, 2, 1, 2], size: 10
	item_cell = pdf.make_cell content: "#{item.material.name} / #{item.material.description}"
	item_cell.style inline_format: true, padding: [2, 2, 2, 5], align: :left, borders: [:left, :bottom, :right], border_widths: [1, 2, 1, 2], size: 10
	item_part = pdf.make_cell content: "#{"$" + item.unit_price.to_s}"
	item_part.style inline_format: true, padding: [2, 5, 2, 2], align: :right, borders: [:left, :bottom, :right], border_widths: [1, 2, 1, 2], size: 10
	item_obs = pdf.make_cell content: "#{item.unit_price != nil ? "$" + (item.requested * item.unit_price).to_s : "$"}"
	item_obs.style inline_format: true, padding: [2, 5, 2, 2], align: :right, borders: [:left, :bottom, :right], border_widths: [1, 2, 1, 2], size: 10
	item_invoice = pdf.make_cell content: ""
	item_invoice.style inline_format: true, padding: [2, 2, 2, 2], align: :left, borders: [:left, :bottom, :right], border_widths: [1, 2, 1, 2], size: 10
	rows<<[item_q_cell, item_u_cell, item_cell, item_part, item_obs, item_invoice]
end

items_title6 = pdf.make_cell content: ""
items_title6.style inline_format: true, align: :center, borders: [:top], border_widths: [2, 2, 2, 2], size: 10, padding: [2, 2, 2, 2]
items_title7 = pdf.make_cell content: ""
items_title7.style inline_format: true, align: :center, borders: [:top], border_widths: [2, 2, 2, 2], size: 10, padding: [2, 2, 2, 2]
items_title8 = pdf.make_cell content: ""
items_title8.style inline_format: true, align: :center, borders: [:top], border_widths: [2, 2, 2, 2], size: 10, padding: [2, 2, 2, 2]
items_title9 = pdf.make_cell content: "<b>Total:</b>"
items_title9.style inline_format: true, align: :center, borders: [:top, :right, :left, :bottom], border_widths: [2, 2, 2, 2], size: 10, padding: [2, 2, 2, 2]
items_title10 = pdf.make_cell content: "$#{total != 0 ? total : ""}"
items_title10.style inline_format: true, align: :right, borders: [:top, :right, :bottom], border_widths: [2, 2, 2, 2], size: 10, padding: [2, 5, 2, 2]
items_title11 = pdf.make_cell content: ""
items_title11.style inline_format: true, align: :center, borders: [:top], border_widths: [2, 2, 2, 2], size: 10, padding: [2, 2, 2, 2]

rows<<[items_title6, items_title7, items_title8, items_title9, items_title10, items_title11]

pdf.table rows, width: pdf.bounds.width

pdf.move_down 5.mm

made_empty_cell = pdf.make_cell content: "Elaboró:"
made_empty_cell.style inline_format: true, align: :center, borders: [:left, :top], border_widths: [2, 2, 2, 2], height: 50, size: 11
request_empty_cell = pdf.make_cell content: "Solicitó:"
request_empty_cell.style inline_format: true, align: :center, borders: [:top], border_widths: [2, 2, 2, 2], height: 50, size: 11
review_empty_cell = pdf.make_cell content: "Revisó:"
review_empty_cell.style inline_format: true, align: :center, borders: [:top], border_widths: [2, 2, 2, 2], height: 50, size: 11
auth_empty_cell = pdf.make_cell content: "Autorizó:"
auth_empty_cell.style inline_format: true, align: :center, borders: [:right, :top], border_widths: [2, 2, 2, 2], height: 50, size: 11

pdf.table [[made_empty_cell, request_empty_cell, review_empty_cell, auth_empty_cell]], width: pdf.bounds.width

f1 = pdf.make_cell content: ""
f1.style borders: [:left, :bottom], border_widths: [2, 2, 2, 2], width:10
made_cell = pdf.make_cell content: "AVMM"
made_cell.style inline_format: true, align: :center, borders: [:bottom, :top], border_widths: [1, 2, 2, 2], size: 10
f2 = pdf.make_cell content: ""
f2.style borders: [:bottom], border_widths: [2, 2, 2, 2], width:5

f3 = pdf.make_cell content: ""
f3.style borders: [:bottom], border_widths: [2, 2, 2, 2], size: 11, width:5
request_cell = pdf.make_cell content: "AVMM"
request_cell.style inline_format: true, align: :center, borders: [:bottom, :top], border_widths: [1, 2, 2, 2], size: 10
f4 = pdf.make_cell content: ""
f4.style borders: [:bottom], border_widths: [2, 2, 2, 2], size: 11, width:5

f5 = pdf.make_cell content: ""
f5.style borders: [:bottom], border_widths: [2, 2, 2, 2], size: 11, width:5
review_cell = pdf.make_cell content: "RLLV"
review_cell.style inline_format: true, align: :center, borders: [:bottom, :top], border_widths: [1, 2, 2, 2], size: 10
f6 = pdf.make_cell content: ""
f6.style borders: [:bottom], border_widths: [2, 2, 2, 2], size: 11, width:5

f7 = pdf.make_cell content: ""
f7.style borders: [:bottom], border_widths: [2, 2, 2, 2], size: 11, width:5
auth_cell = pdf.make_cell content: "RGLLL"
auth_cell.style inline_format: true, align: :center, borders: [:bottom, :top], border_widths: [1, 2, 2, 2], size: 10
f8 = pdf.make_cell content: ""
f8.style borders: [:bottom, :right], border_widths: [2, 2, 2, 2], size: 11, width:10

pdf.table [[f1, made_cell, f2, f3, request_cell, f4, f5, review_cell, f6, f7, auth_cell, f8]], width: pdf.bounds.width

pdf.render
