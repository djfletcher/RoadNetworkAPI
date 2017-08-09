# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

file = File.read('../../intersections_array_points.txt')
points = eval(file)

points.each_with_index do |point, idx|
  Intersection.create!(
    longitude: point[0],
    latitude: point[1]
  )
  puts "completed point #{idx + 1} of #{points.length}" if idx % 10000 == 0
end
