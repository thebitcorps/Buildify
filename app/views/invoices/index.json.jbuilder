json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :amount, :status, :invoice_date, :payment_id, :receipt_folio, :folio
end