# == Schema Information
#
# Table name: road_points
#
#  id           :integer          not null, primary key
#  latitude     :decimal(10, 6)   not null
#  longitude    :decimal(10, 6)   not null
#  road_edge_id :integer          not null
#

class RoadPoint < ActiveRecord::Base

  belongs_to :road_edge

  def self.to_big_decimal(coordinate)
    bd_lat = BigDecimal.new(coordinate[:latitude], 10).truncate(6)
    bd_lng = BigDecimal.new(coordinate[:longitude], 10).truncate(6)
    { latitude: bd_lat, longitude: bd_lng }
  end

  def intersections
    self.road_edge.intersections
  end

end
