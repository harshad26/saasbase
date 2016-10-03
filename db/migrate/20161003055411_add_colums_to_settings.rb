class AddColumsToSettings < ActiveRecord::Migration
  def change
  	add_column :settings, :distance_unit, :string
  	add_column :settings, :start_location, :string
  	add_column :settings, :zoom_level, :integer
  	add_column :settings, :show_radius, :string
  	add_column :settings, :default_radius, :integer
  	add_column :settings, :numOf_results, :integer
  end
end
