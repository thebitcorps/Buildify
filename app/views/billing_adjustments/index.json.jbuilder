json.array!(@adjustments) do |adjustment|
  json.extract! adjustment, :id, :amount, :payment_type, :adjustment_date, :payment_id, :folio, :reference, :account
end
