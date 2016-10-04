json.extract! @invoice, :id, :amount, :status, :invoice_date, :payment_id, :receipt_folio, :folio
json.provider do
  provider = @invoice.provider
  json.extract! provider, :id,:name, :zipcode, :neighborhood, :number, :city , :street, :telephone, :email
  json.description provider.address
end