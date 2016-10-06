json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :amount, :status, :payment_id, :receipt_folio, :folio, :observations
  json.invoice_date invoice.invoice_date.strftime('%d/%m/%Y')
  json.provider do
    provider = invoice.provider
    json.extract! provider, :id,:name, :zipcode, :neighborhood, :number, :city , :street, :telephone, :email
    json.description provider.address
  end
end