class RemoveTimestampsFromRoadEdges < ActiveRecord::Migration
  def change
    remove_column :road_edges, :created_at
    remove_column :road_edges, :updated_at
    remove_column :intersections, :created_at
    remove_column :intersections, :updated_at
  end
end
