class CreateRoadPoints < ActiveRecord::Migration
  def change
    create_table :road_points do |t|
      t.numeric :latitude, null: false
      t.numeric :longitude, null: false
      t.integer :road_edge_id, null: false
    end
    add_index :road_points, :latitude
    add_index :road_points, :longitude
  end
end
