require "prawn/measurement_extensions"

pdf = Prawn::Document.new

logo_cell = pdf.make_cell image: "#{Rails.root}/app/assets/images/allpino_logo.png", image_width: 80, borders: [:left, :top]
head_cell = pdf.make_cell content: "<b>Madereria y Construcciones Allpino S.A De C.V</b><br>Agustin Yañez 141-1 PB Fracc. Villas De La Universidad<br>C.P. 20029 Aguascalientes, Ags. México<br>Tel. y Fax: 01-449-914-93-88<br>E-mail: allpino_cotizaciones@yahoo.com"
head_cell.style inline_format: true, align: :left, padding: [15, 15, 15, 0], borders: [:top, :right], size: 10
pdf.table [[logo_cell, head_cell]], width: pdf.bounds.width

title_cell = pdf.make_cell content: "<b>Requisición</b>"
title_cell.style inline_format: true, align: :center, padding: [5, 0, 5, 0], borders: [:top, :left, :right]
pdf.table [[title_cell]], width: pdf.bounds.width

construction_title_cell = pdf.make_cell content: "Obra"
construction_title_cell.style inline_format: true, align: :center, padding: [5, 0, 5, 0], borders: [:left], size: 10

folio_title_cell = pdf.make_cell content: "Folio"
folio_title_cell.style inline_format: true, align: :center, padding: [5, 0, 0, 0], borders: [], size: 10

date_title_cell = pdf.make_cell content: "Fecha"
date_title_cell.style inline_format: true, align: :center, padding: [5, 0, 0, 0], borders: [:right], size: 10

construction_cell = pdf.make_cell content: "<b>#{@requisition.construction.title}</b>"
construction_cell.style inline_format: true, align: :center, padding: [0, 0, 5, 0], borders: [:left]

folio_cell = pdf.make_cell content: "<b>#{@requisition.formated_folio}</b>"
folio_cell.style inline_format: true, align: :center, padding: [0, 0, 5, 0], borders: []

date_cell = pdf.make_cell content: "<b>#{spanish_formated_date @requisition.requisition_date, false}</b>"
date_cell.style inline_format: true, align: :center, padding: [0, 0, 5, 0], borders: [:right]

pdf.table [	[construction_title_cell, folio_title_cell, date_title_cell],
			[construction_cell, folio_cell, date_cell]], width: pdf.bounds.width

items_title = pdf.make_cell content: "<b>Artículo</b>"
items_title.style inline_format: true, align: :center, borders: [:left, :top], border_lines: [:dashed, :solid, :solid, :solid], size: 10
items_title2 = pdf.make_cell content: "<b>Cantidad</b>"
items_title2.style inline_format: true, align: :center, borders: [:right, :top], border_lines: [:dashed, :solid, :solid, :solid], size: 10


pdf.table [[items_title, items_title2]], width: pdf.bounds.width

@requisition.item_materials.each_with_index do |item, index|
	item_cell = pdf.make_cell content: "#{item.material.name}"
	item_cell.style inline_format: true, padding: [5, 5, 5, 20], align: :left, borders: [:left]
	item_q_cell = pdf.make_cell content: "#{item.requested} #{item.measure_unit}"
	item_q_cell.style inline_format: true, padding: [5, 20, 5, 5], align: :right, borders: [:right]

	pdf.table [[item_cell, item_q_cell]], width: pdf.bounds.width
end

items_inf_cell = pdf.make_cell content: "<b>#{@requisition.item_materials.count}</b> artículos enlistados"
items_inf_cell.style inline_format: true, align: :center, border_lines: [:dashed, :solid, :solid, :solid], size: 10

inf_cell = pdf.make_cell content: "#{!@requisition.pending? ? "*Esta requisición ya ha sido procesada, y se han generado las órdenes de compra correspondientes." : "Esta requisición esta esperando ha ser procesada."}"
inf_cell.style inline_format: true, align: :center, size: 10


pdf.table [[items_inf_cell], [inf_cell]], width: pdf.bounds.width

pdf.render