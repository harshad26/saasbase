class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :email
      t.string :url
      t.text :description
      t.text :categories
      t.string :custom_field_1
      t.string :custom_field_2
      t.string :custom_field_3
      t.string :image_url
      t.string :custom_marker_url
      t.string :lat
      t.string :long

      t.timestamps null: false
    end
  end
end
