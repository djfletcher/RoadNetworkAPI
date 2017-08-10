class ChangeColumnTypeInIntersectionsTable < ActiveRecord::Migration
  def change
    change_column :intersections, :latitude, :numeric
    change_column :intersections, :longitude, :numeric
  end
end
