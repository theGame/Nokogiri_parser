json.array!(@contents) do |content|
  json.extract! content, :url, :filter1, :filter2, :filter3, :timeout, :description
  json.url content_url(content, format: :json)
end
