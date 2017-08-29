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

  def self.within_box(northeast, southwest)
    Intersection.where(
      latitude: southwest[:latitude]..northeast[:latitude],
      longitude: southwest[:longitude]..northeast[:longitude]
    )
  end

  def self.offsetted(num_rows)
    Intersection.offset(num_rows).limit(5000)
  end

  # simple breadth first search
  def self.path(from_id, to_id)
    # predecessors is a hash where each key is an intersection that points
    # to the intersection immediately before it in the search
    predecessors = {}
    q = Queue.new
    q << Intersection.find_by_id(from_id)
    until q.empty?
      intersection = q.deq
      # need to write helper method to extract path from predecessors hash
      return intersection if intersection.id == to_id
      intersection.neighboring_intersections.each do |neighbor|
        # check whether this neighbor has already been visited
        if !predecessors[neighbor]
          return neighbor if intersection.id == to_id
          predecessors[neighbor] = intersection
          q << neighbor
        end
      end
    end

    raise "No path from intersection with id #{from_id} to intersection with id #{to_id}"
  end

  def road_edges
    self.road_edges1 + self.road_edges2
  end

  def neighboring_intersections
    road_edges.map(&:intersections).flatten.uniq(&:id)
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

  def to_coordinate_hash
    { longitude: self.longitude.to_f, latitude: self.latitude.to_f }
  end

end
