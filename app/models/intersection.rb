# == Schema Information
#
# Table name: intersections
#
#  id        :integer          not null, primary key
#  latitude  :decimal(10, 6)   not null
#  longitude :decimal(10, 6)   not null
#

class Intersection < ActiveRecord::Base

  has_many :road_edges1,
    class_name: :RoadEdge,
    foreign_key: :intersection1_id,
    primary_key: :id

  has_many :road_edges2,
    class_name: :RoadEdge,
    foreign_key: :intersection2_id,
    primary_key: :id

  def self.offsetted(num_rows)
    Intersection.offset(num_rows).limit(5000)
  end

  def road_edges
    self.road_edges1 + self.road_edges2
  end

  def neighboring_intersections
    road_edges.map(&:intersections)
  end

end
