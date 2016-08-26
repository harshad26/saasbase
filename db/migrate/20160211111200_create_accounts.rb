class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :company_name
      t.string :company_address_1
      t.string :company_address_2
      t.string :company_city
      t.string :company_zipcode
      t.string :company_country
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end
  end
end
