json.array!(@providers) do |provider|
  json.extract! provider, :id,:name, :zipcode, :neighborhood, :number, :city , :street, :telephone, :email
  json.description provider.address
end
