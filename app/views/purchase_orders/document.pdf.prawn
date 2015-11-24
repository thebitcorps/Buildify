require "prawn/measurement_extensions"
pdf = Prawn::Document.new

logo_cell = pdf.make_cell image: "#{Rails.root}/app/assets/images/allpino_logo.png", image_width: 80, borders: [:left, :top]
head_cell = pdf.make_cell content: "<b>Madereria y Construcciones Allpino S.A De C.V</b><br>Agustin Yañez 141-1 PB Fracc. Villas De La Universidad<br>C.P. 20029 Aguascalientes, Ags. México<br>Tel. y Fax: 01-449-914-93-88<br>E-mail: allpino_cotizaciones@yahoo.com"
head_cell.style inline_format: true, align: :left, padding: [15, 15, 15, 0], borders: [:top, :right], size: 10
pdf.table [[logo_cell, head_cell]], width: pdf.bounds.width

title_cell = pdf.make_cell content: "<b>Orden de  Compra</b>"
title_cell.style inline_format: true, align: :center, padding: [5, 0, 5, 0], borders: [:top, :left, :right]
pdf.table [[title_cell]], width: pdf.bounds.width

provider_title_cell = pdf.make_cell content: "Proveedor"
provider_title_cell.style inline_format: true, align: :center, padding: [5, 0, 5, 0], borders: [:left], size: 10

provider_cell = pdf.make_cell content: "<b>#{@purchase_order.provider.name}</b>"
provider_cell.style inline_format: true, align: :center, padding: [0, 0, 5, 0], borders: [:left], size: 10

delivery_a_title_cell = pdf.make_cell content: "#{@purchase_order.delivery_place == 'ship' ? "Se envía a la obra en" : "Se recoge con proveedor en"}"
delivery_a_title_cell.style inline_format: true, align: :center, padding: [5, 0, 5, 0], borders: [], size: 10

delivery_a_cell = pdf.make_cell content: "<b>#{@purchase_order.delivery_address}</b>"
delivery_a_cell.style inline_format: true, align: :center, padding: [0, 0, 5, 0], borders: [], size: 10

delivery_r_title_cell = pdf.make_cell content: "Persona Autorizada"
delivery_r_title_cell.style inline_format: true, align: :center, padding: [5, 0, 5, 0], borders: [:right], size: 10

delivery_r_cell = pdf.make_cell content: "<b>#{@purchase_order.delivery_receiver}</b>"
delivery_r_cell.style inline_format: true, align: :center, padding: [0, 0, 5, 0], borders: [:right], size: 10

pdf.table [	[provider_title_cell, delivery_a_title_cell, delivery_r_title_cell],
			[provider_cell, delivery_a_cell, delivery_r_cell]], width: pdf.bounds.width

construction_title_cell = pdf.make_cell content: "Obra"
construction_title_cell.style inline_format: true, align: :center, padding: [5, 0, 5, 0], borders: [:left], size: 10

requisition_title_cell = pdf.make_cell content: "Requisición"
requisition_title_cell.style inline_format: true, align: :center, padding: [5, 0, 5, 0], borders: [], size: 10

folio_title_cell = pdf.make_cell content: "Folio de orden"
folio_title_cell.style inline_format: true, align: :center, padding: [5, 0, 0, 0], borders: [], size: 10

date_title_cell = pdf.make_cell content: "Fecha de emisión"
date_title_cell.style inline_format: true, align: :center, padding: [5, 0, 0, 0], borders: [:right], size: 10

construction_cell = pdf.make_cell content: "<b>#{@purchase_order.construction.title}</b>"
construction_cell.style inline_format: true, align: :center, padding: [0, 0, 5, 0], borders: [:left]

requisition_cell = pdf.make_cell content: "<b>#{@purchase_order.requisition.formated_folio}</b>"
requisition_cell.style inline_format: true, align: :center, padding: [0, 0, 5, 0], borders: []

folio_cell = pdf.make_cell content: "<b>#{@purchase_order.formated_folio}</b>"
folio_cell.style inline_format: true, align: :center, padding: [0, 0, 5, 0], borders: []

date_cell = pdf.make_cell content: "<b>#{spanish_formated_date @purchase_order.created_at, false}</b>"
date_cell.style inline_format: true, align: :center, padding: [0, 0, 5, 0], borders: [:right]

pdf.table [	[construction_title_cell, requisition_title_cell, folio_title_cell, date_title_cell],
			[construction_cell, requisition_cell, folio_cell, date_cell]], width: pdf.bounds.width

items_title = pdf.make_cell content: "<b>Artículo</b>"
items_title.style inline_format: true, align: :center, borders: [:left, :top], border_lines: [:dashed, :solid, :solid, :solid], size: 10
items_title2 = pdf.make_cell content: "<b>Cantidad</b>"
items_title2.style inline_format: true, align: :center, borders: [:top], border_lines: [:dashed, :solid, :solid, :solid], size: 10
items_title3 = pdf.make_cell content: "<b>Precio Unidad</b>"
items_title3.style inline_format: true, align: :center, borders: [:top], border_lines: [:dashed, :solid, :solid, :solid], size: 10
items_title4 = pdf.make_cell content: "<b>Total</b>"
items_title4.style inline_format: true, align: :center, borders: [:right, :top], border_lines: [:dashed, :solid, :solid, :solid], size: 10


headers = [items_title, items_title2, items_title3, items_title4]
items_table = [headers]

total_amount = 0

@purchase_order.item_materials.each_with_index do |item, index|
	item_cell = pdf.make_cell content: "#{item.material.name}"
	item_cell.style inline_format: true, padding: [5, 5, 5, 20], align: :left, borders: [:left]
	
	item_q_cell = pdf.make_cell content: "#{item.requested} #{item.measure_unit}"
	item_q_cell.style inline_format: true, padding: [5, 0, 5, 0], align: :center, borders: []

	item_u_cell = pdf.make_cell content: "#{item.unit_price == nil ? "N/A" : number_to_currency(item.unit_price)}"
	item_u_cell.style inline_format: true, padding: [5, 0, 5, 0], align: :center, borders: []

	item_t_cell = pdf.make_cell content: "#{item.unit_price == nil ? "N/A" : number_to_currency(item.unit_price * item.requested)}"
	item_t_cell.style inline_format: true, padding: [5, 20, 5, 5], align: :right, borders: [:right]

	total_amount += item.unit_price == nil ? 0 : item.unit_price * item.requested

	items_table<<[item_cell, item_q_cell, item_u_cell, item_t_cell]
end

pdf.table items_table, width: pdf.bounds.width

items_inf_cell = pdf.make_cell content: "<b>#{@purchase_order.item_materials.count}</b> artículos enlistados"
items_inf_cell.style inline_format: true, align: :center, borders: [:left, :top, :bottom], border_lines: [:dashed, :solid, :solid, :solid], size: 10, padding: [5, 5, 20, 5]

total_title_cell = pdf.make_cell content: "<b>Total:</b>"
total_title_cell.style inline_format: true, align: :right, borders: [:top, :bottom], border_lines: [:dashed, :solid, :solid, :solid], padding: [5, 5, 20, 5]

total_cell = pdf.make_cell content: "<b>#{total_amount == 0 ? "N/A" : (number_to_currency total_amount)}</b>"
total_cell.style inline_format: true, align: :right, borders: [:top, :bottom, :right], border_lines: [:dashed, :solid, :solid, :solid], padding: [5, 20, 20, 5]

pdf.table [[items_inf_cell, total_title_cell, total_cell]], width: pdf.bounds.width

middle_cell = pdf.make_cell content: ""
middle_cell.style borders: [:top, :left, :right], padding: [20, 20, 20, 20]
pdf.table [[middle_cell]], width: pdf.bounds.width

paga_cell_1 = pdf.make_cell content: ""
paga_cell_1.style borders: [:left, :bottom]
paga_cell_2 = pdf.make_cell content: ""
paga_cell_2.style borders: [:bottom]
paga_cell_3 = pdf.make_cell content: ""
paga_cell_3.style borders: [:right, :bottom]

requested_cell = pdf.make_cell content: "Solicitó"
requested_cell.style align: :center, borders: [:top, :bottom], border_lines: [:dashed, :solid, :solid, :solid], size: 10

autorized_cell = pdf.make_cell content: "Autoizó"
autorized_cell.style align: :center, borders: [:top, :bottom], border_lines: [:dashed, :solid, :solid, :solid], size: 10

pdf.table [[paga_cell_1, requested_cell, paga_cell_2, autorized_cell, paga_cell_3]], width: pdf.bounds.width

pdf.render
