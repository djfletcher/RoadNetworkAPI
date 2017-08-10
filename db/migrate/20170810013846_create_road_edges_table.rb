class CreateRoadEdgesTable < ActiveRecord::Migration
  def change
    create_table :road_edges do |t|
      t.integer :intersection1_id, null: false
      t.integer :intersection2_id, null: false
      t.string :street_name
      t.timestamps
    end
    add_index :road_edges, :intersection1_id
    add_index :road_edges, :intersection2_id
    add_index :road_edges, :street_name
  end
end
