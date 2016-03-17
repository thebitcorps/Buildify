json.array!(@payments) do |payment|
  json.extract! payment, :id, :amount,:concept,:payment_date,:construction_id,:paid_amount
end
