json.array!(@providers) do |provider|
  json.extract! provider, :id, :name, :zipcode, :neighborhood, :number, :city , :street, :telephone, :email
  json.compound_name provider.compound_name
  json.description provider.address
end
