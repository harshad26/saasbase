class AddAccIdToStores < ActiveRecord::Migration
  def change
    add_column :stores, :account_id, :integer
  end
end
