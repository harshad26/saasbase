class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :account_id
      t.string :google_api_key

      t.timestamps null: false
    end
  end
end
