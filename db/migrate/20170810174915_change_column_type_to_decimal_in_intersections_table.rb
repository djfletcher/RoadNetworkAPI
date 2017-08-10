class ChangeColumnTypeToDecimalInIntersectionsTable < ActiveRecord::Migration
  def change
    change_column :intersections, :latitude, :decimal
    change_column :intersections, :longitude, :decimal
  end
end
