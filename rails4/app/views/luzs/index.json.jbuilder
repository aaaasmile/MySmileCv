json.array!(@luzs) do |luz|
  json.extract! luz, :id
  json.url luz_url(luz, format: :json)
end
