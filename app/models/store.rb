class Store < ActiveRecord::Base
	belongs_to :user
	attr_accessible :id, :name, :address, :phone, :email, :url, :description, :categories, :custom_field_1, :custom_field_2, :custom_field_3, :image_url, :custom_marker_url, :lat, :long, :created_at, :updated_at, :account_id

	def self.search(search)
	  where("lower(name) LIKE ? OR lower(address) LIKE ?", "%#{search.downcase}%", "%#{search.downcase}%")
	end

	def self.to_csv
	 CSV.generate do |csv|
	 	csv << column_names
	  # csv << ["Name", "Address", "Phone", "Email", "URL", "Description", "Categories", "Custom field 1", "Custom field 2", "Custom field 3", "Image url", "Custom marker url", "Latitude", "Longitude"]
	  	all.each do |store|
	  		csv << store.attributes.values
	 		# csv << [store.name, store.address, store.phone, store.email, store.url, store.description, store.categories, store.custom_field_1, store.custom_field_2, store.custom_field_3, store.image_url, store.custom_marker_url, store.lat, store.long]
	 	end
	 end
	end
end
