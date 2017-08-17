class AddLengthRoadEdges < ActiveRecord::Migration
  def change
    add_column :road_edges, :length, :real
  end
end
