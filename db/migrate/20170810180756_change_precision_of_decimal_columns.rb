class ChangePrecisionOfDecimalColumns < ActiveRecord::Migration
  def change
    change_column :intersections, :latitude, :decimal, precision: 10, scale: 6
    change_column :intersections, :longitude, :decimal, precision: 10, scale: 6
    change_column :road_points, :latitude, :decimal, precision: 10, scale: 6
    change_column :road_points, :longitude, :decimal, precision: 10, scale: 6
  end
end
