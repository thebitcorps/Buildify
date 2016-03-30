json.array!(@petty_cashes) do |petty_cash|
  json.extract! petty_cash, :id, :closing_date, :construction_id, :amount
  json.url petty_cash_url(petty_cash, format: :json)
end
