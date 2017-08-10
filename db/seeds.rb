# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'


NORTHEAST = [-122.3462101020676, 37.8123578039731]
SOUTHWEST = [-122.62458645470844, 37.698000517492105]

def within_sf(latitude, longitude)
  SOUTHWEST[1] < latitude && latitude < NORTHEAST[1] &&
  SOUTHWEST[0] < longitude && longitude < NORTHEAST[0]
end

def is_intersection?(latitude, longitude)
  Intersection.exists?(latitude: latitude, longitude: longitude)
end


# INTERSECTIONS
# =================
# file = File.read('../intersections_and_endpoints_array.txt')
# points = eval(file)
#
# points.each_with_index do |point, idx|
#   longitude = point[0]
#   latitude = point[1]
#   if within_sf(latitude, longitude)
#     Intersection.create!(
#       longitude: longitude,
#       latitude: latitude
#     )
#   end
#   puts "completed point #{idx + 1} of #{points.length}" if idx % 10000 == 0
# end



# ROAD EDGES
# ================
file = File.read('../san-francisco_california.imposm-geojson/san-francisco_california_roads.geojson')
roads = JSON.parse(file)['features']

roads.each_with_index do |road, road_idx|
  prev_intersection = nil
  road['geometry']['coordinates'].each do |coord|
    longitude = coord[0]
    latitude = coord[1]
    if within_sf(latitude, longitude) && is_intersection?(latitude, longitude)
      this_intersection = Intersection.where(latitude: latitude, longitude: longitude)
      if prev_intersection
        RoadEdge.create!(
          intersection1_id: prev_intersection.id,
          intersection2_id: this_intersection.id,
          name: road['properties']['name']
        )
      end
      prev_intersection = this_intersection
    end
  end
  puts "Completed #{road_idx + 1} of #{roads.length}" if road_idx % 10000 == 0
end
