class ChangePrecisionOfDecimalColumns < ActiveRecord::Migration
  def change
    change_column :intersections, :latitude, :decimal, precision: 6
    change_column :intersections, :longitude, :decimal, precision: 6
    change_column :road_edges, :latitude, :decimal, precision: 6
    change_column :road_edges, :longitude, :decimal, precision: 6
    change_column :road_points, :latitude, :decimal, precision: 6
    change_column :road_points, :longitude, :decimal, precision: 6
  end
end
