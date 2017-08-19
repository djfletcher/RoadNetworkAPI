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

def within_sf?(latitude, longitude)
  SOUTHWEST[1] < latitude && latitude < NORTHEAST[1] &&
  SOUTHWEST[0] < longitude && longitude < NORTHEAST[0]
end

# def is_intersection?(latitude, longitude)
#   Intersection.exists?(latitude: latitude, longitude: longitude)
# end

def is_intersection?(latitude, longitude)
  Intersection.exists?(
    latitude: BigDecimal.new(latitude, 10).truncate(6),
    longitude: BigDecimal.new(longitude, 10).truncate(6)
  )
end

def is_road_point?(latitude, longitude)
  RoadPoint.exists?(
    latitude: BigDecimal.new(latitude, 10).truncate(6),
    longitude: BigDecimal.new(longitude, 10).truncate(6)
  )
end


# INTERSECTIONS
# =================
# file = File.read('../intersections_and_endpoints_array.txt')
# points = eval(file)
#
# points.each_with_index do |point, idx|
#   longitude = point[0]
#   latitude = point[1]
#   if within_sf?(latitude, longitude)
#     Intersection.create!(
#       longitude: longitude,
#       latitude: latitude
#     )
#   end
#   puts "completed point #{idx + 1} of #{points.length}" if idx % 10000 == 0
# end



# ROAD EDGES
# ================
# def create_road_edge(id1, id2, street_name)
#   RoadEdge.create!(
#     intersection1_id: id1,
#     intersection2_id: id2,
#     street_name: street_name
#   )
# end

# def create_road_point(latitude, longitude, road_edge_id)
#   RoadPoint.create!(
#     latitude: latitude,
#     longitude: longitude,
#     road_edge_id: road_edge_id
#   )
# end

# def connect_intersections_edges_and_roadpoints(roads)
#   roads.each_with_index do |road, road_idx|
#     prev_intersection = nil
#     roadpoints = []
#     road['geometry']['coordinates'].each do |coord|
#       longitude = coord[0].round(6)
#       latitude = coord[1].round(6)
#       if within_sf?(latitude, longitude)
#         roadpoints << coord
#         if is_intersection?(latitude, longitude)
#           this_intersection = Intersection.where(latitude: latitude, longitude: longitude).first
#           if prev_intersection
#             road_edge = create_road_edge(prev_intersection.id, this_intersection.id, road['properties']['name'])
#             roadpoints.each { |lon, lat| create_road_point(lat, lon, road_edge.id) }
#             roadpoints = []
#           end
#           prev_intersection = this_intersection
#         end
#       end
#     end
#     puts "Completed #{road_idx + 1} of #{roads.length}" if road_idx % 10000 == 0
#   end
# end

# file = File.read('../san-francisco_california.imposm-geojson/san-francisco_california_roads.geojson')
# roads = JSON.parse(file)['features']
# connect_intersections_edges_and_roadpoints(roads)


# FINDING LENGTHS OF ROAD EDGES
# ================

include Geokit::Mappable::ClassMethods

def distance(pt1, pt2)
  return 0 if pt1.nil? || pt2.nil?
  # Geokit takes latitude and longitude in reverse order
  from = [pt1[:latitude], pt1[:longitude]]
  to = [pt2[:latitude], pt2[:longitude]]
  # Using #distance_between method from Geokit::Mappable module
  distance_between(
    from,
    to,
    units: :kms,
    formula: :flat
  )
end

def find_roadpoint(coordinate)
  bd_coord = RoadPoint.to_big_decimal(coordinate)
  RoadPoint.where(
    longitude: bd_coord[:longitude],
    latitude: bd_coord[:latitude]
  ).first
end


def save_length_of_road_edge!(this_roadpoint, prev_roadpoint, length, problematic_border_points)
  # Separate logic to handle the case when prev_roadpoint is also an intersection
  # => i.e. you cannot simply call prev_roadpoint.road_edge
  if is_intersection?(prev_roadpoint[:latitude], prev_roadpoint[:longitude])
    road_edge = RoadEdge.edge_between_intersection_coordinates(
      this_roadpoint,
      prev_roadpoint
    )
  else
    roadpoint = find_roadpoint(prev_roadpoint)
    if roadpoint.nil?
      # There are a very few roadpoints
      problematic_border_points[:count] += 1
      return
    else
      road_edge = roadpoint.road_edge
    end
  end
  road_edge.update_attribute(:length, length)
end

def end_of_edge?(this_roadpoint, prev_roadpoint)
  prev_roadpoint && is_intersection?(this_roadpoint[:latitude], this_roadpoint[:longitude])
end

def find_length_of_all_road_edges(roads, problematic_border_points)
  roads.each_with_index do |road, road_idx|
    prev_roadpoint = nil
    length = 0
    road['geometry']['coordinates'].each do |longitude, latitude|
      this_roadpoint = {
        longitude: longitude.round(6),
        latitude: latitude.round(6)
      }
      if within_sf?(this_roadpoint[:latitude], this_roadpoint[:longitude])
        length += distance(prev_roadpoint, this_roadpoint)
        if end_of_edge?(this_roadpoint, prev_roadpoint)
          save_length_of_road_edge!(this_roadpoint, prev_roadpoint, length, problematic_border_points)
          # Then reset the length to 0 for the next road edge
          length = 0
        end
        prev_roadpoint = this_roadpoint
      end
    end
    puts "Completed #{road_idx + 1} of #{roads.length}" if road_idx % 10000 == 0
  end
  puts "#{problematic_border_points[:count]} coordinates fell along the boundaries of SF and lost information on the length of their edges."
end


file = File.read('../../Desktop/san-francisco_california.imposm-geojson/san-francisco_california_roads.geojson')
roads = JSON.parse(file)['features']
find_length_of_all_road_edges(roads, { count: 0 })
# First seeding script returned 21 problematic_border_points and 107 RoadEdges with length null
# and one RoadEdge with length 0
