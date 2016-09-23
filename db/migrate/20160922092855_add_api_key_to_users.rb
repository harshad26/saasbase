class AddApiKeyToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :api_key, index: true, foreign_key: true
  end
end
