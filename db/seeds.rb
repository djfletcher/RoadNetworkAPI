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
file = File.read('../intersections_and_endpoints_array.txt')
points = eval(file)

points.each_with_index do |point, idx|
  longitude = point[0]
  latitude = point[1]
  if within_sf(latitude, longitude)
    Intersection.create!(
      longitude: longitude,
      latitude: latitude
    )
  end
  puts "completed point #{idx + 1} of #{points.length}" if idx % 10000 == 0
end



# ROAD EDGES
# ================
# file = File.read('../san-francisco_california.imposm-geojson/san-francisco_california_roads.geojson')
# roads = JSON.parse(file)['features']
#
# roads.each_with_index do |road, idx|
#   intersection1, intersection2 = nil, nil
#   road['geometry']['coordinates'].each do |coord|
#     longitude = coord[0]
#     latitude = coord[1]
#     if within_sf(latitude, longitude) && is_intersection?(latitude, longitude)
#
#     end
#   end
#
#   # Add 1 to start point and end point of each road, so that they will be counted as intersections
#   road_start = road['geometry']['coordinates'].first
#   road_end = road['geometry']['coordinates'].last
#   [road_start, road_end].each { |coord| points[coord.to_s] += 1 }
# end
