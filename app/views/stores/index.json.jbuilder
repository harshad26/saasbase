json.array!(@stores) do |store|
  json.extract! store, :id, :name, :address, :phone, :email, :url, :description, :categories, :custom_field_1, :custom_field_2, :custom_field_3, :image_url, :custom_marker_url, :lat, :long
  json.url store_url(store, format: :json)
end
