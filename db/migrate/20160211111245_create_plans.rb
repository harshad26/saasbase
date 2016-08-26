class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :stripe_plan_id
      t.string :name

      t.timestamps null: false
    end
  end
end
