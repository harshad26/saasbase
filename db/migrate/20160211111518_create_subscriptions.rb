class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :account, index: true
      t.string   "stripe_token"
      t.string   "stripe_customer_id"
      t.string   "stripe_subscription_id"
      t.string   "stripe_plan_id"
      t.string   "last_4_digits"
      t.datetime "created_at",                     :null => false
      t.datetime "updated_at",                     :null => false
    end
    add_foreign_key :subscriptions, :accounts
  end
end