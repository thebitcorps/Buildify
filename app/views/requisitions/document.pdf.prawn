require "prawn/measurement_extensions"

pdf = Prawn::Document.new

logo_cell = pdf.make_cell image: "#{Rails.root}/app/assets/images/allpino_logo_80px.png", content:"sksdfsadfsadfasdfasdfdsafasddlsj"
logo_cell.style borders: [:left, :top], image_width: 55, width: 80, padding: [15, 0, -20, 10]
head_cell = pdf.make_cell content: "<b>Madereria y Construcciones Allpino S.A De C.V</b><br><br>Agustin Yañez 141-1 PB Fracc. Villas De La Universidad<br>C.P. 20029 Aguascalientes, Ags. México<br>Tel. y Fax: 01-449-914-93-88<br>E-mail: allpino_cotizaciones@yahoo.com"
head_cell.style inline_format: true, align: :left, padding: [15, 0, 0, 0], borders: [:top], size: 10

requisition_cell = pdf.make_cell content: "<b>Requisición</b>"
requisition_cell.style inline_format: true, align: :center, borders: [], size: 12, padding:[15, 0, 0, 0]
folio_cell = pdf.make_cell content: "<b>#{@requisition.formated_folio}</b>"
folio_cell.style inline_format: true, align: :center, borders: [], size: 12, :text_color => "2A718C", padding: [5, 0, 0, 0]
date_cell = pdf.make_cell content: "#{spanish_formated_date @requisition.requisition_date, false}"
date_cell.style inline_format: true, align: :center, borders: [], size: 12, padding: [5, 0, 0, 0]
construction_cell = pdf.make_cell content: "#{@requisition.construction.title}"
construction_cell.style inline_format: true, align: :center, borders: [], size: 12, padding: [5, 0, 0, 0]
inf_table = pdf.make_table [[requisition_cell], [folio_cell], [date_cell], [construction_cell]]

inf_cell = pdf.make_cell content: inf_table
inf_cell.style inline_format: true, align: :center, borders: [:right, :top], size: 12, width: 180

pdf.table [[logo_cell, head_cell, inf_cell]], width: pdf.bounds.width

art_cell = pdf.make_cell content: "<b>Artículos</b>"
art_cell.style inline_format: true, align: :center, borders: [:right, :top, :left], size: 12
pdf.table [[art_cell]], width: pdf.bounds.width

items_title = pdf.make_cell content: "<b>Cantidad</b>"
items_title.style inline_format: true, align: :center, borders: [:left, :top], border_lines: [:dashed, :solid, :solid, :solid], size: 10
items_title2 = pdf.make_cell content: "<b>Descripcion</b>"
items_title2.style inline_format: true, align: :center, borders: [:right, :left, :top], border_lines: [:dashed, :solid, :solid, :solid], size: 10
items_title3 = pdf.make_cell content: "<b>Unidad</b>"
items_title3.style inline_format: true, align: :center, borders: [:right, :top], border_lines: [:dashed, :solid, :solid, :solid], size: 10

rows = [[items_title, items_title2, items_title3]]

@requisition.item_materials.each_with_index do |item, index|
	item_q_cell = pdf.make_cell content: "#{item.requested}"
	item_q_cell.style inline_format: true, padding: [5, 0, 5, 0], align: :center, borders: [:left, :top], size: 11
	item_cell = pdf.make_cell content: "#{item.material.name} #{item.material.description}"
	item_cell.style inline_format: true, padding: [5, 5, 5, 5], align: :left, borders: [:left, :right, :top], size: 11
	item_u_cell = pdf.make_cell content: "#{item.measure_unit}"
	item_u_cell.style inline_format: true, padding: [5, 0, 5, 0], align: :center, borders: [:right, :top], size: 11
	rows<<[item_q_cell, item_cell, item_u_cell]
end

pdf.table rows, width: pdf.bounds.width

items_inf_cell = pdf.make_cell content: "<b>#{@requisition.item_materials.count}</b> artículos enlistados"
items_inf_cell.style inline_format: true, align: :center, border_lines: [:dashed, :solid, :solid, :solid], size: 10

pdf.table [[items_inf_cell], ], width: pdf.bounds.width


pdf.render
