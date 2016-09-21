class AddApiKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :api_key_id, :string
  end
end
