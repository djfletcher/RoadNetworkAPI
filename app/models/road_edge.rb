# == Schema Information
#
# Table name: road_edges
#
#  id               :integer          not null, primary key
#  intersection1_id :integer          not null
#  intersection2_id :integer          not null
#  street_name      :string
#  length           :float
#

class RoadEdge < ActiveRecord::Base

  has_many :road_points

  belongs_to :intersection1,
    class_name: :Intersection,
    foreign_key: :intersection1_id,
    primary_key: :id

  belongs_to :intersection2,
    class_name: :Intersection,
    foreign_key: :intersection2_id,
    primary_key: :id


  def self.offsetted(num_rows)
    RoadEdge.offset(num_rows).limit(5000)
  end

  def self.offsetted_intersection_pairs(num_rows)
    all_intersections = Intersection.all.index_by(&:id)
    RoadEdge.offsetted(num_rows).map do |edge|
      [all_intersections[edge.intersection1_id], all_intersections[edge.intersection2_id]]
    end
  end

  def self.offsetted_intersection_pairs_by_id(num_rows)
    RoadEdge.offsetted(num_rows).map(&:intersection_ids)
  end

  def self.edge_between_intersections(intersection1, intersection2)
    id1 = intersection1.id
    id2 = intersection2.id
    intersection1.road_edges.each do |edge|
      if edge.intersection1_id == id1 && edge.intersection2_id == id2 ||
         edge.intersection1_id == id2 && edge.intersection2_id == id1
        return edge
      end
    end

    nil
  end

  def self.edge_between_intersections_from_coordinates(raw_coord1, raw_coord2)
    # This method assumes that both coordinates are passed in as hashes, not intersection objects
    parsed_coord1 = RoadPoint.to_big_decimal(coord1)
    parsed_coord2 = RoadPoint.to_big_decimal(coord2)
    intersection1 = Intersection.where(latitude: parsed_coord1[:latitude], longitude: parsed_coord1[:longitude])
    intersection2 = Intersection.where(latitude: parsed_coord2[:latitude], longitude: parsed_coord2[:longitude])
    raise "#{raw_coord1} is not an intersection" if intersection1.nil?
    raise "#{raw_coord2} is not an intersection" if intersection2.nil?
    RoadEdge.edge_between_intersections(intersection1, intersection2)
  end

  def intersections
    [self.intersection1, self.intersection2]
  end

  def intersection_ids
    [self.intersection1_id, self.intersection2_id]
  end

  def circular?
    # A circular road edge has the same intersection at both ends
    self.intersection1_id == self.intersection2_id
  end

end
