require "prawn/measurement_extensions"

pdf = Prawn::Document.new

head_cell = pdf.make_cell content: "<b>Madereria y Construcciones Allpino S.A De C.V</b><br>Agustin Yañez 141-1 PB Fracc. Villas De La Universidad Aguascalientes, Ags. México"
head_cell.style align: :center 
head_foot = pdf.make_table [["<b>TEL:</b> 01 (449) 914 9388", "<b>E-mail:</b> allpino_cotizaciones@yahoo.com", "<b>R.F.C.:</b> MCA-990225-MJ0"]], cell_style: { inline_format: true }
head_table = pdf.make_table [[head_cell], [head_foot]], cell_style: { inline_format: true }

pdf.table [[head_table]]

pdf.move_down 15

invoice_head = pdf.make_table [["Recibimos de: <b>#{@invoice.provider.name}</b>", "Con folio: <b>#{@invoice.folio}</b>", "El <b>#{spanish_formated_date(@invoice.invoice_date, false)}</b>"]], cell_style: { inline_format: true }

pdf.table [[invoice_head]], :position => :center

pdf.move_down 15

amount_cell = pdf.make_cell content: "#{number_to_currency @invoice.amount}"
amount_cell.style align: :right, borders: [:top, :right, :bottom]
amount_title_cell = pdf.make_cell content: "Importe", borders: [:left, :top, :bottom]
pdf.table [[amount_title_cell, amount_cell]], :column_widths => [100, 440]

pdf.render