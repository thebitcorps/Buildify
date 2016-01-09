json.array!(@extensions) do |extension|
  json.extract! extension, :id, :date, :construction_id, :amount
  json.url extension_url(extension, format: :json)
end
