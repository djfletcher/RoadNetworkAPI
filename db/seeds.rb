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

def is_intersection?(latitude, longitude)
  Intersection.exists?(latitude: latitude, longitude: longitude)
end

# def is_intersection?(latitude, longitude)
#   Intersection.exists?(
#     latitude: BigDecimal.new(latitude, 10).truncate(6),
#     longitude: BigDecimal.new(longitude, 10).truncate(6)
#   )
# end


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

def distance(pt1, pt2)
  Math.sqrt(
    ((pt2[0] - pt1[0])**2 + (pt2[1] - pt1[1])**2).abs
  ).round(6)
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
            lenght += distance(prev_roadpoint, this_roadpoint)
            # 2. save the total length as the length of the road edge to roadedge with the last roadpoint's road_edge_id

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

[[-122.40673185831763, 37.655209037537475], [-122.40555596112144, 37.657999540742], [-122.40350977091872, 37.66074327292682], [-122.39568585103946, 37.666610688967296], [-122.39489057606635, 37.66743957537213], [-122.39272796122854, 37.669689529641005], [-122.3899846481389, 37.67332467722832], [-122.34282286410473, 37.50938739164721], [-122.33951025215154, 37.50736953227721], [-122.12534516617441, 37.690695417184145]].each_slice(2) { |a| puts distance(a[0],a[1]) }
