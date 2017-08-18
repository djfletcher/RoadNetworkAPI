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
  # Geokit takes latitude and longitude in reverse order
  from = [pt1[1], pt1[0]]
  to = [pt2[1], pt2[0]]
  # Using #distance_between method from Geokit::Mappable module
  distance_between(
    from,
    to,
    units: :kms,
    formula: :flat
  )
end

def order_points_along_road_edge(road_edge)
  intersections = road_edge.intersections
  road_points = road_edge.road_points
  if road_points.include?()
end

def find_length_of_road_edges(roads)
  roads.each_with_index do |road, road_idx|
    prev_roadpoint = nil
    length = 0
    road['geometry']['coordinates'].each do |coord|
      longitude = coord[0].round(6)
      latitude = coord[1].round(6)
      this_roadpoint = [longitude, latitude]
      if within_sf?(latitude, longitude)
        if is_intersection?(latitude, longitude)
          if prev_roadpoint
            # 1. find distance from last roadpoint to this intersection
            length += distance(prev_roadpoint, this_roadpoint)
            # 2. save the total length as the length of the road edge to roadedge with the last roadpoint's road_edge_id
            if is_intersection?(prev_roadpoint[0], prev_roadpoint[1])
              road_edge = prev_roadpoint.road_edges.select do |edge|

              end
            else
              road_edge = prev_roadpoint.road_edge
            end
            roadedge = RoadEdge
            # 3. reset the total length to 0 and the prev_roadpoint to this intersection

          end
        else
          # increment the length by the distance from the last roadpoint to this roadpoint
        end
      end
    end
    puts "Completed #{road_idx + 1} of #{roads.length}" if road_idx % 10000 == 0
  end
end



# file = File.read('../../Desktop/san-francisco_california.imposm-geojson/san-francisco_california_roads.geojson')
# roads = JSON.parse(file)['features']
