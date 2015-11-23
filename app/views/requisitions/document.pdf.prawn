require "prawn/measurement_extensions"

pdf = Prawn::Document.new


logo_cell = pdf.make_cell image: "#{Rails.root}/app/assets/images/allpino_logo.png", image_width: 50, borders: [:left, :top, :bottom]
head_cell = pdf.make_cell content: "<b>Madereria y Construcciones Allpino S.A De C.V</b><br>Agustin Yañez 141-1 PB Fracc. Villas De La Universidad Aguascalientes, Ags. México"
head_cell.style inline_format: true, align: :center, padding: [15, 0, 0, 0], borders: [:top, :bottom, :right]
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

folio_cell = pdf.make_cell content: "<b>#{@requisition.folio}</b>"
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
end

pdf.render