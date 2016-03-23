json.array!(@measure_units) do |measure_unit|
  json.extract! measure_unit ,:id,:unit, :abbreviation
end