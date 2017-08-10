# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

NORTHEAST = [-122.3462101020676, 37.8123578039731]
SOUTHWEST = [-122.62458645470844, 37.698000517492105]

def within_sf(latitude, longitude)
  SOUTHWEST[1] < latitude && latitude < NORTHEAST[1] &&
  SOUTHWEST[0] < longitude && longitude < NORTHEAST[0]
end

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
