class CreateIntersectionsTable < ActiveRecord::Migration
  def change
    create_table :intersections do |t|
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.timestamps
    end
    add_index :intersections, :latitude
    add_index :intersections, :longitude
  end
end
