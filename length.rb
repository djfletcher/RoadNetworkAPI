require 'json'

file = File.read('../san-francisco_california.imposm-geojson/san-francisco_california_roads.geojson')
roads = JSON.parse(file)['features']
puts roads.length
