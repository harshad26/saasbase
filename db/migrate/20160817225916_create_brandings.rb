class CreateBrandings < ActiveRecord::Migration
  def change
    create_table :brandings do |t|
      t.string :name
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :country
      t.string :postal_code

      t.timestamps null: false
    end
  end
end
