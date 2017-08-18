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

  def neighbor(road_edge)
    return self if road_edge.circular?
    if road_edge.intersection1_id == self.id
      Intersection.find_by_id(road_edge.intersection2_id)
    elsif road_edge.intersection2_id == self.id
      Intersection.find_by_id(road_edge.intersection1_id)
    else
      raise "Intersection with id #{self.id} is not part of RoadEdge with id #{road_edge.id}"
    end
  end

end
